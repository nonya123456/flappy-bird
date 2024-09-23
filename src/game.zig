const Allocator = @import("std").mem.Allocator;
const c = @import("c.zig").c;
const Bird = @import("bird.zig").Bird;

pub const Game = struct {
    bird: *Bird,
    allocator: Allocator,

    pub fn init(allocator: Allocator) !Game {
        const bird = try allocator.create(Bird);
        bird.* = Bird{
            .position = .{ .x = 324, .y = 324 },
            .size = 30,
            .fallSpeed = 0,
        };

        return Game{ .bird = bird, .allocator = allocator };
    }

    pub fn deinit(self: Game) void {
        self.allocator.destroy(self.bird);
    }

    pub fn update(self: *Game) void {
        self.bird.update();
    }

    pub fn draw(self: Game) void {
        self.bird.draw();
    }
};
