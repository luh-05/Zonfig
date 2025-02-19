# Zonfig
**Zonfig** is a simple module for `build.zig`, that enables adding `.zon` files as modules for _comptime_ configuration.

## Why
I wanted to create a library, that can be configured at comptime. For that I needed some _notation format_. My mind has immediately gone to _JSON_, as I have used that in the past for the same purpose. But that was quite annoying to do, as I ended writing a very sketchy little translator from JSON to Zig.  
When I was pondering ways to get around having to do this again, I thought of _ZON_, which is as approachable as _JSON_ but very very close in syntax to a _Zig module_.  

So I decided to make a little translation library for translating _ZON_ to a _Zig module_ for use in `build.zig`.

## How to use
Using **Zonfig** is very easy. Just include it in your `build.zig.zon` and include it on your `build.zig` like this:
```zig
const zonfig = @import("zonfig");
```
And call `addConfig`:
```zig
try zonfig.addConfig(b, your_module, "./config.zon", "config");
```
That's all you need to access you're newly generated config module! Simply add
```zig
const config = @import("config").config;
```
to your module and you're good to go!
### Using tooling
#### DISCLAIMER
This is not a feature yet, but this will likely come at some point. Including this does not hurt though.
Use `@hasField`, `@field`, and `@typeInfo` for now to achieve the same thing!
---
To use the provided tooling follow these steps:
In your `build.zig`, create a dependency like this and add the `zonfig` module defined in it to your module:
```zig
const zonfig_dep = b.dependency("zonfig", .{
  .target = target,
  .optimize = optimize,
});

your_module.addImport("zonfig", zonfig_dep.module("zonfig"));
```
This allows you to import **zonfig** by adding:
```zig
const zonfig = @import("zonfig");
```
