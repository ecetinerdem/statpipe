const std = @import("std");
const flags = @import("flags.zig");

pub fn runPython(allocator: std.mem.Allocator, args: flags.Args) u8 {
    const python_path = "python3";
    const python_script = "../analyzer/";

    var child = std.process.Child([]const u8).init(&.{
        python_path,
        python_script,
    }, allocator);

    var argv = std.ArrayList([]const u8).init(allocator);
    defer argv.deinit();

    try argv.appendSlice(&.{
        python_path,
        "--name",
        args.name,
        "--path",
        python_script,
        "--columns",
        args.columns,
        "--target",
        args.target,
        "--model",
        args.model,
        "--output",
        args.output,
        "--port",
        args.port,
    });

    if (args.clean) {
        try argv.append("--clean");
    }

    if (args.verbose) {
        try argv.append("--verbose");
    }

    if (args.visualize) {
        try argv.append("--visualize");
    }

    child.argv = argv.items;

    child.stdout_behaviour = .Inherit;
    child.stderr_behaviour = .Inherit;

    std.debug.print("Running Python script: {s} {s}...\n", .{ python_path, python_script });

    try child.spawn();

    const result = try child.wait();

    return switch (result) {
        .Exited => |code| code,
        .Signal => |sig| {
            std.debug.print("Python was killed by signal {}\n", .{sig});
            return 1;
        },
        .Stopped => |sig| {
            std.debug.print("Python was stopped by signal {}\n", .{sig});
            return 1;
        },
        .Unknown => |code| {
            std.debug.print("Python exited with unknown status {}\n", .{code});
            return 1;
        },
    };
}
