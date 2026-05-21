const std = @import("std");
const flags = @import("flags.zig");
const analyzer = @import("run_analysis.zig");

pub fn main(init: std.process.Init) !void {

    // Create the allocator here and clean everything here
    const allocator = init.gpa;

    const args: flags.Args = try flags.parse_flags(allocator, init.minimal.args);

    inline for (std.meta.fields(@TypeOf(args))) |field| {
        const value = @field(args, field.name);
        if (@TypeOf(value) == []const u8) {
            std.debug.print("{s: <12} = {s}\n", .{ field.name, value });
        } else {
            std.debug.print("{s: <12} = {any}\n", .{ field.name, value });
        }
    }

    const result: u8 = analyzer.runPython(allocator, args);

    std.debug.print("Result of Python script: {d}", .{result});
}
