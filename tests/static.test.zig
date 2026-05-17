const std = @import("std");
const zstatic = @import("ziez_static");

test "StaticConfig defaults" {
    const config = zstatic.StaticConfig{ .root = "./public" };
    try std.testing.expectEqualStrings("./public", config.root);
    try std.testing.expectEqualStrings("/", config.prefix);
    try std.testing.expect(config.max_age == 86400);
    try std.testing.expect(config.etag == true);
    try std.testing.expectEqualStrings("index.html", config.index);
    try std.testing.expect(config.dotfiles == .deny);
}

test "middleware returns valid Middleware" {
    const mw = zstatic.middleware(.{ .root = "./public" });
    try std.testing.expect(mw.ptr != null);
    try std.testing.expect(mw.deinit_fn != null);
}
