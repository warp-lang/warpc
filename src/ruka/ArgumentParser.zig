// @author: ruka-lang
// @created: 2024-09-13

const libruka = @import("ruka").prelude;
const Transport = libruka.Transport;
const constants = @import("constants.zig");

const std = @import("std");
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const LinearFifo = std.fifo.LinearFifo;

subcommands: LinearFifo(Subcommand, .Dynamic),
options: ArrayList(Option),

transport: *Transport,

allocator: Allocator,

const ArgumentParser = @This();

const Subcommand = enum {
    new,
    build,
    @"test",
    run,
    repl,
    version,
    help
};

pub const subcommandsMap = std.StaticStringMap(Subcommand).initComptime(.{
    .{"new", .new},
    .{"build", .build},
    .{"test", .@"test"},
    .{"run", .run},
    .{"repl", .repl},
    .{"version", .version},
    .{"help", .help}
});

const Option = enum {

};

pub fn init(allocator: Allocator) !*ArgumentParser {
    const argument_parser = try allocator.create(ArgumentParser);
    errdefer argument_parser.deinit();

    argument_parser.* = .{
        .subcommands = .init(allocator),
        .options = .init(allocator),

        .transport = try .init(allocator, null, null),

        .allocator = allocator
    };

    return argument_parser;
}

pub fn deinit(self: *ArgumentParser) void {
    self.subcommands.deinit();
    self.options.deinit();
    self.allocator.destroy(self);
}

pub fn parse(self: *ArgumentParser) !void {
    var args = try std.process.argsWithAllocator(self.allocator);
    defer args.deinit();

    std.debug.assert(args.skip());

    const subcommand_arg = args.next();
    if (subcommand_arg == null) {
        try self.transport.printStderr("{s}\n{s}\n\nExpected subcommand argument\n", .{
            constants.usage,
            constants.commands
        });

        std.posix.exit(1);
    }

    if (subcommandsMap.get(subcommand_arg.?)) |subcommand| {
        try self.subcommands.writeItem(subcommand);
    } else {
        try self.transport.printStderr("{s}\n{s}\n\nInvalid subcommand: {s}\n", .{
            constants.usage,
            constants.commands,
            subcommand_arg.?
        });

        std.posix.exit(1);
    }
}

pub fn getSubcommand(self: *ArgumentParser) ?Subcommand {
    return self.subcommands.readItem();
}

test "test all argumentParser modules" {
    _ = tests;
}

const tests = struct {

};