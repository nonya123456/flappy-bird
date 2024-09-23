const std = @import("std");
const c = @import("c.zig").c;
const Bird = @import("bird.zig").Bird;
const Game = @import("game.zig").Game;

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    var game = try Game.init(allocator);
    defer game.deinit();

    c.InitWindow(1152, 648, "Flappy Bird");
    c.SetTargetFPS(144);
    defer c.CloseWindow();

    while (!c.WindowShouldClose()) {
        game.update();
        c.BeginDrawing();
        c.ClearBackground(c.RAYWHITE);
        game.draw();
        c.EndDrawing();
    }
}
