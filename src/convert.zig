const std = @import("std");

const fileHandler = @import("./fileHandler.zig"); 

const PREFIX = "const ";
const PREFIX2 = " = ";
const SUFFIX = ";";

const ZIG_FILE_ENDING = ".zig";

pub fn convertContent(
    allocator: *std.mem.Allocator, 
    name: []const u8, 
    content: []const u8
) ![]const u8 {
    const name_length = std.mem.len(name);
    const prefix_length = std.mem.len(PREFIX) + name_length + std.mem.len(PREFIX2);
    const suffix_length = std.mem.len(SUFFIX);
    const content_length = std.mem.len(content);

    const buffer_size = prefix_length + content_length + suffix_length;

    const buffer = allocator.alloc(u8, buffer_size);

    try std.fmt.bufPrint(buffer, "{s}{s}{s}{s}{s}", .{
        PREFIX, name, PREFIX2,
        content,
        SUFFIX
    });

    return buffer;
}

pub fn convertFile(
    allocator: *std.mem.Allocator,
    path: []const u8,
    name: []const u8
) ![]const u8 {
    // Convert content into a valid zig module
    var content = try fileHandler.readFile(allocator, path);
    content = try convertContent(allocator, name, content);
    
    // Create Directory if it doesn't exist
    std.fs.cwd().openDir(fileHandler.ZONFIG_DIR, .{}) catch |err| {
        switch (err) {
            std.fs.Dir.OpenError.FileNotFound => {
                try std.fs.cwd().makeDir(fileHandler.ZONFIG_DIR);
            },
            _ => {
                return err;
            }
        }
    };

    // Generate new path
    // +1 for the additional slash
    const buffer_size = std.mem.len(fileHandler.ZONFIG_DIR) + std.mem.len(name) + std.mem.len(ZIG_FILE_ENDING) + 1;
   
    const buffer = allocator.alloc(u8, buffer_size);
    try std.fmt.bufPrint(buffer, "{s}/{s}{s}", .{
        fileHandler.ZONFIG_DIR,
        name,
        ZIG_FILE_ENDING
    });

    try fileHandler.writeFile(buffer, content);

    return buffer;
}
