const std = @import("std");

pub fn FileReader(comptime T: type) type {
    return struct {
        const Self = @This();

        reader: T,

        pub fn init(reader: T) Self {
            return Self{
                .reader = reader,
            };
        }

        pub fn readLine(self: Self, arr: *std.ArrayList(u8)) !void {
            // Clear ArrayList
            arr.clearRetainingCapacity();
            // Read line
            try self.reader.streamUntilDelimiter(arr.writer(), '\n', null);
        }
    };
}

pub fn isNumber(char: u8) bool {
    return (char >= 48) and (char <= 57);
}
