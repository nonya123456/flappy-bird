const c = @import("c.zig").c;

const GRAVITY = 3000.0;
const JUMP_SPEED = -1000.0;
const SIZE = 25.0;
const BOX_SIZE = 40.0;

pub const Bird = struct {
    position: c.Vector2 = .{ .x = 324.0, .y = 324.0 },
    ySpeed: f32 = 0,

    pub fn draw(self: Bird) void {
        c.DrawCircleV(self.position, SIZE, c.YELLOW);
    }

    pub fn update(self: *Bird) void {
        if (c.GetKeyPressed() == c.KEY_SPACE) {
            self.ySpeed = JUMP_SPEED;
        }

        self.ySpeed += c.GetFrameTime() * GRAVITY;
        self.position.y += c.GetFrameTime() * self.ySpeed;
    }

    pub fn getBox(self: Bird) c.Rectangle {
        return c.Rectangle{
            .x = self.position.x - BOX_SIZE / 2.0,
            .y = self.position.y - BOX_SIZE / 2.0,
            .width = BOX_SIZE,
            .height = BOX_SIZE,
        };
    }
};
