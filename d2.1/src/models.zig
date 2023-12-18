const std = @import("std");
const utils = @import("./utils.zig");

pub const CharType = enum {
    const Self = @This();

    comma,
    semicolon,
    number,
    char,
    space,
    other,

    pub fn getType(char: u8) Self {
        return switch (char) {
            32 => Self.space,
            44 => Self.comma,
            59 => Self.semicolon,
            48...57 => Self.number,
            97...122 => Self.char,
            else => Self.other,
        };
    }
};

pub const Color = enum {
    red,
    green,
    blue,
};

pub const Game = struct {
    const Self = @This();

    id: u8,
    red: u8,
    green: u8,
    blue: u8,
    allocator: std.mem.Allocator,

    pub fn init(id: u8, red: u8, green: u8, blue: u8, allocator: std.mem.Allocator) Game {
        return Game{ .id = id, .red = red, .green = green, .blue = blue, .allocator = allocator };
    }

    pub fn fromStr(self: *Self, str: []u8) !void {
        // Temporal buffer
        var buffer = std.ArrayList(u8).init(self.allocator);
        defer buffer.deinit();

        // Game id
        var i: usize = 5; // 5 is the position of first digit of game id
        while (true) : (i += 1) {
            if (str[i] == ':') {
                break;
            }
            try buffer.append(str[i]);
        }
        self.id = try std.fmt.parseInt(u8, buffer.items, 10);
        buffer.clearAndFree();

        var number_buf: u8 = 0;
        var color_map = std.StringHashMap(Color).init(self.allocator);
        defer color_map.deinit();
        try color_map.put("red", Color.red);
        try color_map.put("green", Color.green);
        try color_map.put("blue", Color.blue);

        i += 2;
        while (i < str.len) : (i += 1) {
            var char_type = CharType.getType(str[i]);
            switch (char_type) {
                CharType.number, CharType.char => try buffer.append(str[i]),
                CharType.space => {
                    number_buf = try std.fmt.parseInt(u8, buffer.items, 10);
                    buffer.clearAndFree();
                },
                CharType.semicolon, CharType.comma => {
                    var color_buf: ?Color = color_map.get(buffer.items);
                    buffer.clearAndFree();
                    switch (color_buf.?) {
                        Color.red => if (number_buf > self.red) {
                            self.red = number_buf;
                        },
                        Color.green => if (number_buf > self.green) {
                            self.green = number_buf;
                        },
                        Color.blue => if (number_buf > self.blue) {
                            self.blue = number_buf;
                        },
                    }
                    i += 1;
                },
                else => break,
            }
        }
        var color_buf: ?Color = color_map.get(buffer.items);
        buffer.clearAndFree();
        switch (color_buf.?) {
            Color.red => if (number_buf > self.red) {
                self.red = number_buf;
            },
            Color.green => if (number_buf > self.green) {
                self.green = number_buf;
            },
            Color.blue => if (number_buf > self.blue) {
                self.blue = number_buf;
            },
        }
    }

    pub fn format(self: Self, comptime fmt: []const u8, options: std.fmt.FormatOptions, writer: anytype) !void {
        _ = options;
        _ = fmt;
        try writer.print("Game ( id: {}, red: {}, green: {}, blue: {} )\n", .{ self.id, self.red, self.green, self.blue });
    }
};
