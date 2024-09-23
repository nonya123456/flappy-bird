const Random = @import("std").Random;
const c = @import("c.zig").c;

const WIDTH = 100.0;
const HOLE = 240.0;
const SPEED = -240.0;
const SCREEN_HEIGHT = 648.0;

pub const Pipe = struct {
    x_position: f32,
    hole_center: f32,

    pub fn draw(self: Pipe) void {
        const top_rec = c.Rectangle{
            .x = self.x_position,
            .y = 0,
            .width = WIDTH,
            .height = self.hole_center - HOLE / 2.0,
        };

        const bottom_rec = c.Rectangle{
            .x = self.x_position,
            .y = self.hole_center + HOLE / 2.0,
            .width = WIDTH,
            .height = SCREEN_HEIGHT - self.hole_center - HOLE / 2.0,
        };

        c.DrawRectangleRec(top_rec, c.GREEN);
        c.DrawRectangleRec(bottom_rec, c.GREEN);
    }

    pub fn update(self: *Pipe) void {
        self.x_position += SPEED * c.GetFrameTime();
    }
};

pub fn generatePipe(random: Random, x_position: f32) Pipe {
    const randomValue = 74.0 + random.float(f32) * 300.0;
    return Pipe{ .x_position = x_position, .hole_center = randomValue };
}
