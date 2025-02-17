const std = @import("std");

pub const ZONFIG_DIR = ".zonfig/";

pub fn readFile(allocator: *const std.mem.Allocator, path: []const u8) ![]const u8 {
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();
        
    const file_size = try file.getEndPos();

    const buffer = try allocator.alloc(u8, file_size);

     _ = try file.readAll(buffer);

    return buffer;
}

pub fn writeFile(path: []const u8, content: []const u8) !void {
    const file = try std.fs.cwd().createFile(path, .{
        .read = false,
        .truncate = true,
    });
    defer file.close();

    try file.writeAll(content);
}
