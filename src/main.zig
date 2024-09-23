const c = @import("c.zig").c;
const Bird = @import("bird.zig").Bird;

pub fn main() !void {
    var b = Bird{ .position = .{ .x = 324, .y = 324 }, .size = 30 };
    c.InitWindow(1152, 648, "My Window");
    c.SetTargetFPS(144);
    defer c.CloseWindow();

    while (!c.WindowShouldClose()) {
        c.BeginDrawing();
        c.ClearBackground(c.RAYWHITE);
        b.draw();
        c.EndDrawing();
    }
}
