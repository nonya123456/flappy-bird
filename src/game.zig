const Allocator = @import("std").mem.Allocator;
const c = @import("c.zig").c;
const Bird = @import("bird.zig").Bird;
const Pipe = @import("pipe.zig").Pipe;

pub const Game = struct {
    bird: *Bird,
    pipe: *Pipe,
    allocator: Allocator,

    pub fn init(allocator: Allocator) !Game {
        const bird = try allocator.create(Bird);
        errdefer allocator.destroy(bird);
        bird.* = Bird{};

        const pipe = try allocator.create(Pipe);
        errdefer allocator.destroy(pipe);
        pipe.* = Pipe{ .hole_center = 324.0, .x_position = 648.0 };

        return Game{ .bird = bird, .pipe = pipe, .allocator = allocator };
    }

    pub fn deinit(self: Game) void {
        self.allocator.destroy(self.bird);
        self.allocator.destroy(self.pipe);
    }

    pub fn update(self: *Game) void {
        self.bird.update();
        self.pipe.update();
    }

    pub fn draw(self: Game) void {
        self.bird.draw();
        self.pipe.draw();
    }
};
