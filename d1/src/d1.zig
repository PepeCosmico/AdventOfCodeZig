const std = @import("std");
const utils = @import("./utils.zig");

const TEST_FILE_PATH: *const [26]u8 = "./assets/input_d2_test.txt";
const FILE_PATH: *const [21]u8 = "./assets/input_d1.txt";

pub fn d1() !void {
    var file = try std.fs.cwd().openFile(FILE_PATH, .{});
    defer file.close();

    // lines will get read into this
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();
    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();
    // Things are _a lot_ slower if we don't use a BufferedReader
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    // Map for reading numbers
    var numbers_map = std.StringHashMap(u8).init(allocator);
    try numbers_map.put("one", 1 + 48);
    try numbers_map.put("two", 2 + 48);
    try numbers_map.put("three", 3 + 48);
    try numbers_map.put("four", 4 + 48);
    try numbers_map.put("five", 5 + 48);
    try numbers_map.put("six", 6 + 48);
    try numbers_map.put("seven", 7 + 48);
    try numbers_map.put("eight", 8 + 48);
    try numbers_map.put("nine", 9 + 48);

    var reader_arr = std.ArrayList(u8).init(allocator);
    var sum: u32 = 0;

    while (true) {
        utils.readLine(&reader, &arr) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };
        sum += try utils.searchNumber(&numbers_map, &arr, &reader_arr);
    }

    std.debug.print("Sum: {}\n", .{sum});
}
