const std = @import("std");

pub const Args = struct {
    name: []const u8,
    path: []const u8,
    columns: []const u8, // Be careful this still contains columns with coma seperated
    target: []const u8,
    model: []const u8,
    clean: bool,
    output: []const u8,
    verbose: bool,
    visualize: bool,
    port: []const u8,
};

pub fn parse_flags(allocator: std.mem.Allocator, arg_iter: std.process.Args) !Args {
    const args = try arg_iter.toSlice(allocator);
    defer allocator.free(args);

    // Name of the analysis that will be done
    var name: ?[]const u8 = null;
    // Path to csv file which we weill direct to Python.
    var path_to_csv: ?[]const u8 = null;

    // This will be the list of columns seperated with coma.
    //Later we may need to turn it into array or may be use as it is. Don't know yet
    var columns: ?[]const u8 = null;

    // Target column
    var target: ?[]const u8 = null;

    // if no model provided use linear regression
    // No other model unless ı know what ı am doing
    var model: ?[]const u8 = "linear_regression";

    // if data is clean no cleaning needed just tell python to train and give the results
    var is_clean: bool = false;

    // Json output if visualize true then Go backend read this file to struct and serve. if not then zig will print this json to terminal
    var output_file: ?[]const u8 = "result.json";

    // Are we giving more information or not
    var is_verbose: bool = false;

    // are we serving and visualizing  resulted data with Go backend react front end or not?
    var visualize: bool = false;

    // Which port are we serving. if not specified use 8080 or we may ned to change if our backend uses. we may need different port. Not sure yet
    var port: ?[]const u8 = "8080";

    // To not to have args[0] which is executable path start from 1
    var i: usize = 1;

    while (i < args.len) : (i += 1) {
        const arg = args[i];

        // BUG: you were checking 'if (i < args.len)' AFTER already reading args[i].
        // the i < args.len check must happen BEFORE doing i += 1 and reading args[i+1].
        if (std.mem.eql(u8, arg, "--name")) {
            i += 1;
            if (i < args.len) name = args[i];
        } else if (std.mem.eql(u8, arg, "--path")) {
            i += 1;
            if (i < args.len) path_to_csv = args[i];
        } else if (std.mem.eql(u8, arg, "--columns")) {
            i += 1;
            if (i < args.len) columns = args[i];
        } else if (std.mem.eql(u8, arg, "--target")) {
            i += 1;
            if (i < args.len) target = args[i];
        } else if (std.mem.eql(u8, arg, "--model")) {
            i += 1;
            if (i < args.len) model = args[i];
        } else if (std.mem.eql(u8, arg, "--output")) {
            i += 1;
            if (i < args.len) output_file = args[i];
        } else if (std.mem.eql(u8, arg, "--clean")) {
            is_clean = true;
            // BUG: --clean and --verbose etc are toggle flags, no value follows them.
            // you were doing i += 1 which skips the next flag entirely.

        } else if (std.mem.eql(u8, arg, "--no-clean")) {
            is_clean = false;
        } else if (std.mem.eql(u8, arg, "--verbose")) {
            is_verbose = true;
        } else if (std.mem.eql(u8, arg, "--no-verbose")) {
            is_verbose = false;
        } else if (std.mem.eql(u8, arg, "--visualize")) {
            visualize = true;
        } else if (std.mem.eql(u8, arg, "--no-visualize")) {
            visualize = false;
        } else if (std.mem.eql(u8, arg, "--port")) {
            i += 1;
            if (i < args.len) port = args[i];
        }

        // BUG: you had 'return' inside the while loop which exits on the first iteration.
        // all the orelse checks and the return must be OUTSIDE the loop.
    }

    // Validate required flags AFTER the loop is fully done.
    // orelse with a block lets us print help and exit cleanly if missing.
    const resolved_name = name orelse {
        std.debug.print("Error: --name is required.\n\n", .{});
        print_help();
        return error.MissingFlag; // we must return an error, not .{} — .{} is not an Args
    };

    const resolved_path = path_to_csv orelse {
        std.debug.print("Error: --path is required.\n\n", .{});
        print_help();
        return error.MissingFlag;
    };

    const resolved_columns = columns orelse {
        std.debug.print("Error: --columns is required.\n\n", .{});
        print_help();
        return error.MissingFlag;
    };

    const resolved_target = target orelse {
        std.debug.print("Error: --target is required.\n\n", .{});
        print_help();
        return error.MissingFlag;
    };

    return Args{
        .name = resolved_name,
        .path = resolved_path,
        .columns = resolved_columns,
        .target = resolved_target,
        .model = model orelse "linear_regression",
        .clean = is_clean,
        .output = output_file orelse "result.json",
        .verbose = is_verbose,
        .visualize = visualize,
        .port = port orelse "8080",
    };
}

fn print_help() void {
    std.debug.print(
        \\Usage: statpipe [flags]
        \\
        \\Required:
        \\  --name      <string>   Project name
        \\  --path      <string>   Path to csv file
        \\  --columns   <string>   Columns to analyse comma separated e.g. col1,col2,col3
        \\  --target    <string>   Target column to predict
        \\
        \\Optional:
        \\  --model     <string>   Choose the model (default: linear_regression)
        \\  --output    <string>   Path to output file (default: result.json)
        \\  --verbose              Enable verbose logging
        \\  --clean                Enable cleaning the data
        \\  --visualize            Enable visualisation
        \\  --port      <string>   Port to listen on (default: 8080)
        \\
    , .{});
}
