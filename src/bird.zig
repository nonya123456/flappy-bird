const c = @import("c.zig").c;

pub const Bird = struct {
    position: c.Vector2,
    ySpeed: f32,
    gravity: f32 = 3000.0,
    size: f32,

    pub fn draw(self: Bird) void {
        c.DrawCircleV(self.position, self.size, c.GREEN);
    }

    pub fn update(self: *Bird) void {
        if (c.GetKeyPressed() == c.KEY_SPACE) {
            self.ySpeed = -1000.0;
        }

        self.ySpeed += c.GetFrameTime() * self.gravity;
        self.position.y += c.GetFrameTime() * self.ySpeed;
    }
};
