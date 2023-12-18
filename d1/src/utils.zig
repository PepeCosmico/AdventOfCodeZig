const std = @import("std");

pub fn filterWithMap(map: *std.StringHashMap(u8), arr: *std.ArrayList(u8)) ?u8 {
    for (map.keyIterator().items, 0..map.keyIterator().len) |key, _i| {
        _ = _i;
        if (std.mem.containsAtLeast(u8, arr.items, 1, key)) {
            return map.get(key);
        }
    }
    return null;
}

pub fn searchFirst(map: *std.StringHashMap(u8), arr: *std.ArrayList(u8), reader_arr: *std.ArrayList(u8)) !u8 {
    reader_arr.clearRetainingCapacity();
    var res: u8 = 0;
    var i: usize = 0;
    while (true) : (i += 1) {
        try reader_arr.append(arr.items[i]);
        if (isNumber(arr.items[i])) {
            res = arr.items[i];
            break;
        } else if (filterWithMap(map, reader_arr)) |read_num| {
            res = read_num;
            break;
        }
    }
    return res;
}

pub fn searchLast(map: *std.StringHashMap(u8), arr: *std.ArrayList(u8), reader_arr: *std.ArrayList(u8)) !u8 {
    reader_arr.clearRetainingCapacity();
    var res: u8 = 0;
    var i: usize = arr.items.len - 1;
    while (true) : (i -= 1) {
        try reader_arr.insert(0, arr.items[i]);
        if (isNumber(arr.items[i])) {
            res = arr.items[i];
            break;
        } else if (filterWithMap(map, reader_arr)) |read_num| {
            res = read_num;
            break;
        }
    }
    return res;
}

pub fn searchNumber(map: *std.StringHashMap(u8), arr: *std.ArrayList(u8), reader_arr: *std.ArrayList(u8)) !u8 {
    return try joinNumebers(try searchFirst(map, arr, reader_arr), try searchLast(map, arr, reader_arr));
}

pub fn joinNumebers(first: u8, last: u8) !u8 {
    return try std.fmt.parseInt(u8, &[2]u8{ first, last }, 10);
}

pub fn isNumber(char: u8) bool {
    return ((char >= 48) and (char <= 57));
}

pub fn readLine(reader: anytype, arr: *std.ArrayList(u8)) !void {
    // Clear ArrayList
    arr.clearRetainingCapacity();
    // Read line
    try reader.streamUntilDelimiter(arr.writer(), '\n', null);
}

test searchLast {
    // Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // Map
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

    // Input array
    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    const str = "28gtbkszmrtmnineoneightmx";
    for (str) |value| {
        try arr.append(value);
    }
    var reader_arr = std.ArrayList(u8).init(allocator);
    defer reader_arr.deinit();

    const expected: u8 = 56;
    try std.testing.expectEqual(expected, try searchLast(&numbers_map, &arr, &reader_arr));
}

test searchFirst {
    // Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // Map
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

    // Input array
    var arr = std.ArrayList(u8).init(allocator);
    defer arr.deinit();

    const str = "28gtbkszmrtmnineoneightmx";
    for (str) |value| {
        try arr.append(value);
    }
    var reader_arr = std.ArrayList(u8).init(allocator);
    defer reader_arr.deinit();

    const expected: u8 = 50;
    try std.testing.expectEqual(expected, try searchFirst(&numbers_map, &arr, &reader_arr));
}

test filterWithMap {
    // Allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // Map
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

    // Input array
    var arr = std.ArrayList(u8).init(allocator);
    const str = "nine";
    for (str) |value| {
        try arr.append(value);
    }

    // Test
    const expected: u8 = 57;
    try std.testing.expectEqual(expected, filterWithMap(&numbers_map, &arr).?);
}
