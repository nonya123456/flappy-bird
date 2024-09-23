const Random = @import("std").Random;
const Allocator = @import("std").mem.Allocator;
const c = @import("c.zig").c;
const Bird = @import("bird.zig").Bird;
const Pipe = @import("pipe.zig").Pipe;
const generatePipe = @import("pipe.zig").generatePipe;

pub const Game = struct {
    bird: *Bird,
    pipe: *Pipe,
    allocator: Allocator,
    random: Random,

    pub fn init(allocator: Allocator, random: Random) !Game {
        const bird = try allocator.create(Bird);
        errdefer allocator.destroy(bird);
        bird.* = Bird{};

        const pipe = try allocator.create(Pipe);
        errdefer allocator.destroy(pipe);
        pipe.* = generatePipe(random, 648.0);

        return Game{
            .bird = bird,
            .pipe = pipe,
            .allocator = allocator,
            .random = random,
        };
    }

    pub fn deinit(self: Game) void {
        self.allocator.destroy(self.bird);
        self.allocator.destroy(self.pipe);
    }

    pub fn update(self: *Game) !void {
        self.bird.update();
        try self.updatePipes();
    }

    fn updatePipes(self: *Game) !void {
        self.pipe.update();
        if (self.pipe.x_position < -100.0) {
            const new_pipe = try self.allocator.create(Pipe);
            new_pipe.* = generatePipe(self.random, 648.0);
            self.allocator.destroy(self.pipe);
            self.pipe = new_pipe;
        }
    }

    pub fn draw(self: Game) void {
        self.bird.draw();
        self.pipe.draw();
    }
};
