const std = @import("std");

const fileHandler = @import("./fileHandler.zig"); 

const PREFIX = "const ";
const PREFIX2 = " = ";
const SUFFIX = ";";

const ZIG_FILE_ENDING = ".zig";

pub fn convertContent(
    allocator: *const std.mem.Allocator, 
    name: []const u8, 
    content: []const u8
) ![]const u8 {
    const name_length = name.len;
    const prefix_length = PREFIX.len + name_length + PREFIX2.len;
    const suffix_length = SUFFIX.len;
    
    const trimmed_content = std.mem.trimRight(u8, content, &[_]u8{ '\r', '\n'});
    const content_length = trimmed_content.len;

    const buffer_size = prefix_length + content_length + suffix_length;

    const buffer = try allocator.alloc(u8, buffer_size);


    _ = try std.fmt.bufPrint(buffer, "{s}{s}{s}{s}{s}", .{
        PREFIX, name, PREFIX2,
        trimmed_content[0..content_length],
        SUFFIX
    });

    return buffer;
}

pub fn convertFile(
    allocator: *const std.mem.Allocator,
    path: []const u8,
    name: []const u8
) ![]const u8 {
    // Convert content into a valid zig module
    const content = try fileHandler.readFile(allocator, path);
    const converted_content = try convertContent(allocator, name, content);
    defer allocator.free(content);
    defer allocator.free(converted_content);
    
    // Create Directory if it doesn't exist
    if (std.fs.cwd().openDir(fileHandler.ZONFIG_DIR, .{})) |_| {} 
    else |err| {
        if (err == error.FileNotFound) {
            try std.fs.cwd().makeDir(fileHandler.ZONFIG_DIR);
        }
        else {
            return err;
        }
    }

    // Generate new path
    const buffer_size = fileHandler.ZONFIG_DIR.len + name.len + ZIG_FILE_ENDING.len;
   
    const buffer = try allocator.alloc(u8, buffer_size);
    _ = try std.fmt.bufPrint(buffer, "{s}{s}{s}", .{
        fileHandler.ZONFIG_DIR,
        name,
        ZIG_FILE_ENDING
    });

    // Write to file 
    try fileHandler.writeFile(buffer, converted_content);

    return buffer;
}
