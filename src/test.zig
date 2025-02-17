const std = @import("std");
const testing = std.testing;

const zonfig = @import("zonfig.zig");
const convert = @import("convert.zig");
const fileHandler = @import("fileHandler.zig");

fn deleteFileIfExists(file_path: []const u8) !void {
    const cwd = std.fs.cwd();
    if (cwd.statFile(file_path)) |_| {
        try cwd.deleteFile(file_path);
    } else |err| {
        if (err != error.FileNotFound) {
            return err;
        }
    }
}

test "read file" {
    const content = try fileHandler.readFile(&testing.allocator, "./test/foo.zon");
    defer testing.allocator.free(content);
}
test "read file - non existent" {
    _ = try testing.expectError(error.FileNotFound, fileHandler.readFile(&testing.allocator, "./test/bar.zon"));
}

test "write file" {
    const file_path = "./test/temp.zig";
    try deleteFileIfExists(file_path);
    
    try fileHandler.writeFile(file_path, "lorem ipsum");
}
test "write file -- already exists" {
    const file_path = "./test/temp.zig";
    
    // call twice to make sure file already exists
    try fileHandler.writeFile(file_path, "lorem ipsum");
    try fileHandler.writeFile(file_path, "lorem ipsum2");
}

test "convert content" {
    const res = try convert.convertContent(&testing.allocator, "foo", "bar");
    defer testing.allocator.free(res);
    try testing.expectEqualStrings("const foo = bar;", res);
}

test "convert file - name" {
    const file_path = "./test/foo.zon";
    const final_file_path = fileHandler.ZONFIG_DIR ++ "bar.zig";
    try deleteFileIfExists(final_file_path);

    const res = try convert.convertFile(&testing.allocator, file_path, "bar");
    defer testing.allocator.free(res);

    try testing.expectEqualStrings(final_file_path, res);
}
test "convert file - content" {
    const file_path = "./test/foo.zon";
    const final_file_path = fileHandler.ZONFIG_DIR ++ "bar.zig";
    try deleteFileIfExists(final_file_path);

    const res = try convert.convertFile(&testing.allocator, file_path, "bar");
    defer testing.allocator.free(res);
    
    const content = try fileHandler.readFile(&testing.allocator, final_file_path); 
    defer testing.allocator.free(content);

    try testing.expectEqualStrings("const bar = lorem ipsum;", content);
}
