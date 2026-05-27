const std = @import("std");
const flags = @import("flags.zig");
const analyzer = @import("run_analysis.zig");

pub fn main(init: std.process.Init) !void {

    // Create the allocator here and clean everything here
    const allocator = init.gpa;

    // Initialize io
    const io = init.io;

    // Read args from flags
    const args: flags.Args = try flags.parse_flags(allocator, init.minimal.args);

    // Print the args for the moment
    std.debug.print("\n=== Parsed Arguments ===\n\n", .{});
    inline for (std.meta.fields(@TypeOf(args))) |field| {
        const value = @field(args, field.name);
        if (@TypeOf(value) == []const u8) {
            std.debug.print("{s: <12} = {s}\n", .{ field.name, value });
        } else {
            std.debug.print("{s: <12} = {any}\n", .{ field.name, value });
        }
    }

    // Execute Python code to for our ML model
    const analyzer_exit_code: u8 = try analyzer.runPython(io, allocator, args);

    // Print the message so we now exit code
    std.debug.print("Result of Python script: {d}\n", .{analyzer_exit_codee});

    // if exit code 0 then execute Go code for backend launch! (It will serve a backend server so how we will send back a 0 value)
    const backend_exit_code: u8 = try
    if (analyzer_exit_codee == 0) {} else {
        std.debug.print("Non-zero(0) exit code: {d}\n", .{analyzer_exit_codee});
        std.debug.print("Terminating pipeline\n", .{});
        std.process.exit(1);
    }
}
