const std = @import("std");
const ziez = @import("ziez");
const static = @import("static.zig");

pub const StaticConfig = static.StaticConfig;
pub const DotfilePolicy = static.DotfilePolicy;

/// Returns a configured Middleware that can be passed to `app.use()`.
pub fn middleware(config: StaticConfig) ziez.Middleware {
    return static.asMiddleware(config);
}

/// Convenience: registers static file serving middleware on the app in one call.
pub fn setup(app: *ziez.App, config: StaticConfig) void {
    app.use(middleware(config));
}
