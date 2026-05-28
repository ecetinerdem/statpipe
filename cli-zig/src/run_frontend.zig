const std = @import("std");
const flags = @import("flags.zig");

pub fn runFrontend(io: std.Io, allocator: std.mem.Allocator) !std.process.Child {
    var argv: std.ArrayList([]const u8) = .empty;
    defer argv.deinit(allocator);

    try argv.append(allocator, "npm");
    try argv.append(allocator, "run");
    try argv.append(allocator, "dev");

    const child = try std.process.spawn(io, .{
        .argv = argv.items,
        .stdout = .inherit,
        .stderr = .inherit,
        .cwd = .{ .path = "../frontend" }, // adjust to your frontend path
    });

    std.debug.print("Running frontend...\n", .{});

    return child;
}
