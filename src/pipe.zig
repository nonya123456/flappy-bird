const Random = @import("std").Random;
const c = @import("c.zig").c;

const WIDTH = 100.0;
const GAP = 240.0;
const SPEED = -240.0;
const SCREEN_HEIGHT = 648.0;

pub const Pipe = struct {
    x_position: f32,
    gap_center: f32,

    pub fn draw(self: Pipe) void {
        const top_rec = self.getTopBox();
        const bottom_rec = self.getBottomBox();
        c.DrawRectangleRec(top_rec, c.GREEN);
        c.DrawRectangleRec(bottom_rec, c.GREEN);
    }

    pub fn update(self: *Pipe) void {
        self.x_position += SPEED * c.GetFrameTime();
    }

    pub fn isHit(self: Pipe, player_box: c.Rectangle) bool {
        const top_box = self.getTopBox();
        const bottom_box = self.getBottomBox();
        return isOverlapped(top_box, player_box) or isOverlapped(bottom_box, player_box);
    }

    fn getTopBox(self: Pipe) c.Rectangle {
        return c.Rectangle{
            .x = self.x_position,
            .y = 0,
            .width = WIDTH,
            .height = self.gap_center - GAP / 2.0,
        };
    }

    fn getBottomBox(self: Pipe) c.Rectangle {
        return c.Rectangle{
            .x = self.x_position,
            .y = self.gap_center + GAP / 2.0,
            .width = WIDTH,
            .height = SCREEN_HEIGHT - self.gap_center - GAP / 2.0,
        };
    }
};

pub fn generatePipe(random: Random, x_position: f32) Pipe {
    const randomValue = 150.0 + random.float(f32) * 348.0;
    return Pipe{ .x_position = x_position, .gap_center = randomValue };
}

fn isOverlapped(box1: c.Rectangle, box2: c.Rectangle) bool {
    return box1.x < box2.x + box2.width and box2.x < box1.x + box1.width and box1.y < box2.y + box2.height and box2.y < box1.y + box1.height;
}
