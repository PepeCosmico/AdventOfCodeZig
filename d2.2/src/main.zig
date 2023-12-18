const std = @import("std");
const models = @import("./models.zig");
const utils = @import("./utils.zig");

const FILE_PATH: *const [18]u8 = "./assets/input.txt";

pub fn main() !void {
    // lines will get read into this
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    // File
    var file = try std.fs.cwd().openFile(FILE_PATH, .{});
    defer file.close();
    // Things are _a lot_ slower if we don't use a BufferedReader
    var buffered = std.io.bufferedReader(file.reader());
    var reader = buffered.reader();

    const file_reader = utils.FileReader(@TypeOf(reader)).init(reader);

    var buffer = std.ArrayList(u8).init(allocator);
    defer buffer.deinit();

    var sum: usize = 0;

    while (true) {
        file_reader.readLine(&buffer) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };
        var game = models.Game.init(0, 0, 0, 0, allocator);
        try game.fromStr(buffer.items);
        sum += game.red * game.green * game.blue;
    }
    std.debug.print("Sum: {}\n", .{sum});
}
