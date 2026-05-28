const std = @import("std");
const flags = @import("flags.zig");

pub fn runBackendServer(io: std.Io, allocator: std.mem.Allocator, args: flags.Args) !std.process.Child {
    const go_path = ".";

    var argv: std.ArrayList([]const u8) = .empty;
    defer argv.deinit(allocator);

    try argv.append(allocator, "go");
    try argv.append(allocator, "run");
    try argv.append(allocator, go_path);

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

    const child = try std.process.spawn(io, .{
        .argv = argv.items,
        .stdout = .inherit,
        .stderr = .inherit,
        .cwd = .{ .path = "../backend" },
    });

    std.debug.print("Running Go backend: {s}...\n", .{go_path});

    // _ = try child.wait(io);
    return child;
}
