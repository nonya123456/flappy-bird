const std = @import("std");
const c = @import("c.zig").c;
const Bird = @import("bird.zig").Bird;
const Game = @import("game.zig").Game;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var seed: u64 = undefined;
    try std.posix.getrandom(std.mem.asBytes(&seed));
    var prng = std.rand.DefaultPrng.init(seed);
    const random = prng.random();

    var game = try Game.init(allocator, random);
    defer game.deinit();

    c.InitWindow(1152, 648, "Flappy Bird");
    c.SetTargetFPS(144);
    defer c.CloseWindow();

    while (!c.WindowShouldClose()) {
        try game.update();
        c.BeginDrawing();
        c.ClearBackground(c.RAYWHITE);
        game.draw();
        c.EndDrawing();
    }
}
