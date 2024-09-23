const std = @import("std");
const Random = std.Random;
const Allocator = std.mem.Allocator;
const ArrayList = std.ArrayList;
const c = @import("c.zig").c;
const Bird = @import("bird.zig").Bird;
const Pipe = @import("pipe.zig").Pipe;
const generatePipe = @import("pipe.zig").generatePipe;

pub const Game = struct {
    bird: *Bird,
    pipes: ArrayList(Pipe),
    allocator: Allocator,
    random: Random,
    score: i32,

    pub fn init(allocator: Allocator, random: Random) !Game {
        const bird = try allocator.create(Bird);
        errdefer allocator.destroy(bird);
        bird.* = Bird{};

        var pipes = ArrayList(Pipe).init(allocator);
        errdefer pipes.deinit();

        try pipes.append(generatePipe(random, 800.0));
        try pipes.append(generatePipe(random, 1200.0));
        try pipes.append(generatePipe(random, 1600.0));
        try pipes.append(generatePipe(random, 2000.0));

        return Game{
            .bird = bird,
            .pipes = pipes,
            .allocator = allocator,
            .random = random,
            .score = 0,
        };
    }

    pub fn deinit(self: Game) void {
        self.allocator.destroy(self.bird);
        self.pipes.deinit();
    }

    pub fn update(self: *Game) !void {
        self.bird.update();

        var count: usize = 0;
        var i: usize = 0;
        while (i < self.pipes.items.len) {
            var pipe = &self.pipes.items[i];
            const is_in_front_before = pipe.x_position > self.bird.position.x;
            pipe.update();

            const is_in_front_after = pipe.x_position > self.bird.position.x;
            if (is_in_front_before and !is_in_front_after) {
                self.score += 1;
            }

            if (pipe.x_position < -100.0) {
                _ = self.pipes.orderedRemove(i);
                count += 1;
            } else {
                i += 1;
            }
        }

        var j: usize = 0;
        while (j < count) : (j += 1) {
            try self.addNewPipe();
        }
    }

    fn addNewPipe(self: *Game) !void {
        var new_position: f32 = 1600.0;
        if (self.pipes.getLastOrNull()) |last_pipe| {
            new_position = last_pipe.x_position + 400.0;
        }

        try self.pipes.append(generatePipe(self.random, new_position));
    }

    pub fn isGameOver(self: *Game) bool {
        const player_box = self.bird.getBox();

        for (self.pipes.items) |*pipe| {
            if (pipe.isHit(player_box)) {
                return true;
            }
        }

        return false;
    }

    pub fn draw(self: Game) !void {
        self.bird.draw();

        for (self.pipes.items) |*pipe| {
            pipe.draw();
        }

        var buf: [12]u8 = undefined;
        const str = try std.fmt.bufPrint(&buf, "{}", .{self.score});
        buf[str.len] = 0;
        c.DrawText(@ptrCast(str), 20, 20, 48, c.RED);
    }
};
