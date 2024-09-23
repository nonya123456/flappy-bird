const c = @import("c.zig").c;

pub const Bird = struct {
    position: c.Vector2,
    fallSpeed: f32,
    gravity: f32 = 5.0,
    size: f32,

    pub fn draw(self: Bird) void {
        c.DrawCircleV(self.position, self.size, c.GREEN);
    }

    pub fn update(self: *Bird) void {
        self.fallSpeed += c.GetFrameTime() * self.gravity;
        self.position.y += self.fallSpeed;
    }
};
