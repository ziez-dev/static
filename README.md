# ziez-static

Static file serving middleware for [ziez](https://github.com/ziez-dev/ziez).

## Requirements

- Zig 0.16.0+

## Installation

In `build.zig.zon`:

```zig
.dependencies = .{
    .ziez = .{
        .url = "https://github.com/ziez-dev/ziez/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "ziez-0.0.1-zH20Gh1jAwADi2a_88hnfVHclInMW1YPLF_y7SS7CJ5Y",
    },
    .@"ziez-static" = .{
        .url = "https://github.com/ziez-dev/static/archive/refs/tags/v0.0.1.tar.gz",
        .hash = "1220b1fe03d61a1cc83ee28e918e1a2e4f0e0d6d1e23844e0c0e28194a8bbbe9d2e8",
    },
},
```

In `build.zig`:

```zig
const static_dep = b.dependency("ziez-static", .{
    .target = target,
    .optimize = optimize,
});
exe_mod.addImport("ziez_static", static_dep.module("ziez-static"));
```

## Quick Start

```zig
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

    try app.listen( "0.0.0.0:3000");
}
```

## Configuration

**StaticConfig:**

| Option | Type | Default | Description |
|---|---|---|---|
| `root` | `[]const u8` | *(required)* | Root directory to serve files from |
| `prefix` | `[]const u8` | `"/"` | URL path prefix |
| `max_age` | `u32` | `86400` | Cache-Control max-age (seconds) |
| `etag` | `bool` | `true` | Generate ETag headers |
| `index` | `[]const u8` | `"index.html"` | Default file for directory requests |
| `dotfiles` | `DotfilePolicy` | `.deny` | Dotfile handling (`.allow`, `.deny`, `.ignore`) |

## License

MIT
