const std = @import("std");
const flags = @import("flags.zig");

pub fn runPython(io: std.Io, allocator: std.mem.Allocator, args: flags.Args) !u8 {
    const python_path = "python3";
    const python_script = "../analyzer/main.py";

    var argv: std.ArrayList([]const u8) = .empty;
    defer argv.deinit(allocator);

    try argv.append(allocator, python_path);
    try argv.append(allocator, python_script);

    try argv.appendSlice(allocator, &.{
        "--name",    args.name,
        "--path",    args.path,
        "--columns", args.columns,
        "--target",  args.target,
        "--model",   args.model,
        "--output",  args.output,
        "--port",    args.port,
    });

    if (args.clean) try argv.append(allocator, "--clean");
    if (args.verbose) try argv.append(allocator, "--verbose");
    if (args.visualize) try argv.append(allocator, "--visualize");

    var child = try std.process.spawn(io, .{
        .argv = argv.items,
    });

    std.debug.print("Running Python script: {s} {s}...\n", .{ python_path, python_script });

    const exit_code = try child.wait(io);

    return switch (exit_code) {
        .exited => |code| code,
        .signal => |sig| {
            std.debug.print("Python was killed by signal {}\n", .{sig});
            return 1;
        },
        .stopped => |sig| {
            std.debug.print("Python was stopped by signal {}\n", .{sig});
            return 1;
        },
        .unknown => |code| {
            std.debug.print("Python exited with unknown status {}\n", .{code});
            return 1;
        },
    };
}
