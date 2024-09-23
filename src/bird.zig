const c = @import("c.zig").c;

pub const Bird = struct {
    position: c.Vector2,
    size: f32,

    pub fn draw(bird: Bird) void {
        c.DrawCircleV(bird.position, bird.size, c.GREEN);
    }
};
