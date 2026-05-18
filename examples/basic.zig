const std = @import("std");
const ziez = @import("ziez");
const zstatic = @import("ziez_static");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var app = ziez.init(allocator);
    defer app.deinit();

    app.use(zstatic.middleware(.{
        .root = "./public",
        .prefix = "/assets",
        .max_age = 3600,
    }));

    app.get("/", struct {
        fn h(_: *ziez.Request, res: *ziez.Response) !void {
            res.json(.{ .message = "Static files served at /assets/*" });
        }
    }.h);

    try app.listen("0.0.0.0:3000");
}
