const std = @import("std");
const testing = std.testing;

const convert = @import("./convert.zig");

fn createConfigModule(
    b: *std.Build,
    target: *std.Build.ResolvedTarget,
    optimize: *std.builtin.OptimizeMode,
    path: []const u8,
    name: []const u8
) !*std.Build.Module {
    const zig_path = try convert.convertFile(b.allocator, path, name);
    const module = b.addModule(name, .{
        .root_source_file = b.path(zig_path),
        .target = target,
        .optimize = optimize,
    }); 

    return module;
}

pub fn addConfig(b: *std.Build, module: *std.Build.Module, path: []const u8, name: []const u8) !void {
    const config_module = try createConfigModule(b, module.resolved_target.?, module.optimize.?, path, name);

    module.addImport(name, config_module);
}

test "basic add functionality" {
    //try testing.expect(add(3, 7) == 10);
}
