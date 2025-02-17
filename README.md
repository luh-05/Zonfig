# Zonfig
**Zonfig** is a simple comptime library for `build.zig`, that enables adding `.zon` files as modules for _comptime_ configuration.

## Why
I wanted to create a library, that can be configured at comptime. For that I needed some _notation format_. My mind has immediately gone to _JSON_, as I have used that in the past for the same purpose. But that was quite annoying to do, as I ended writing a very sketchy little translator from JSON to Zig.  
When I pondering ways to get around having to do this again, I thought of _ZON_, which is as approachable as _JSON_ but very very close in syntax to a _Zig module_.  

So I decided to make a little translation library for translating _ZON_ to a _Zig module_ for use in `build.zig`.

## How to use
Using **Zonfig** is very easy. Just include it in your `build.zig` and call `addConfig` with your `Builder`, the `Module` you want to import the configuration to, the _path_ of the `.zon` file, and the _name_ by which you later want to reference the configuration in code.  
Once that's done you can just import your configuration module like any other and write code depending on it.

### Unknown keys
If you have a configuration that has unknown keys at the time of writing the code, that also works. For that look into `@hasField`, `@field`, and `@typeInfo`.
