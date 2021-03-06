const std = @import("std");
const TestContext = @import("../../src/test.zig").TestContext;

const wasi = std.zig.CrossTarget{
    .cpu_arch = .wasm32,
    .os_tag = .wasi,
};

pub fn addCases(ctx: *TestContext) !void {
    {
        var case = ctx.exe("wasm function calls", wasi);

        case.addCompareOutput(
            \\export fn _start() u32 {
            \\    foo();
            \\    bar();
            \\    return 42;
            \\}
            \\fn foo() void {
            \\    bar();
            \\    bar();
            \\}
            \\fn bar() void {}
        ,
            "42\n",
        );

        case.addCompareOutput(
            \\export fn _start() i64 {
            \\    bar();
            \\    foo();
            \\    foo();
            \\    bar();
            \\    foo();
            \\    bar();
            \\    return 42;
            \\}
            \\fn foo() void {
            \\    bar();
            \\}
            \\fn bar() void {}
        ,
            "42\n",
        );

        case.addCompareOutput(
            \\export fn _start() f32 {
            \\    bar();
            \\    foo();
            \\    return 42.0;
            \\}
            \\fn foo() void {
            \\    bar();
            \\    bar();
            \\    bar();
            \\}
            \\fn bar() void {}
        ,
        // This is what you get when you take the bits of the IEE-754
        // representation of 42.0 and reinterpret them as an unsigned
        // integer. Guess that's a bug in wasmtime.
            "1109917696\n",
        );

        case.addCompareOutput(
            \\export fn _start() u32 {
            \\    foo(10, 20);
            \\    return 5;
            \\}
            \\fn foo(x: u32, y: u32) void {}
        , "5\n");
    }

    {
        var case = ctx.exe("wasm locals", wasi);

        case.addCompareOutput(
            \\export fn _start() u32 {
            \\    var i: u32 = 5;
            \\    var y: f32 = 42.0;
            \\    var x: u32 = 10;
            \\    return i;
            \\}
        , "5\n");

        case.addCompareOutput(
            \\export fn _start() u32 {
            \\    var i: u32 = 5;
            \\    var y: f32 = 42.0;
            \\    var x: u32 = 10;
            \\    foo(i, x);
            \\    i = x;
            \\    return i;
            \\}
            \\fn foo(x: u32, y: u32) void {
            \\    var i: u32 = 10;
            \\    i = x;
            \\}
        , "10\n");
    }

    {
        var case = ctx.exe("wasm binary operands", wasi);

        case.addCompareOutput(
            \\export fn _start() u32 {
            \\    var i: u32 = 5;
            \\    i += 20;
            \\    return i;
            \\}
        , "25\n");

        case.addCompareOutput(
            \\export fn _start() u32 {
            \\    var i: u32 = 5;
            \\    i += 20;
            \\    var result: u32 = foo(i, 10);
            \\    return result;
            \\}
            \\fn foo(x: u32, y: u32) u32 {
            \\    return x + y;
            \\}
        , "35\n");
    }
}
