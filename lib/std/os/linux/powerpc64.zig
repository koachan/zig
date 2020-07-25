usingnamespace @import("../bits.zig");

pub fn syscall0(number: SYS) usize {
    return asm volatile ("sc"
        : [ret] "={r3}" (-> usize)
        : [number] "{r0}" (@enumToInt(number))
        : "memory"
    );
}

pub fn syscall1(number: SYS, arg1: usize) usize {
    return asm volatile ("sc"
        : [ret] "={r3}" (-> usize)
        : [number] "{r0}" (@enumToInt(number)),
          [arg1] "{r3}" (arg1)
        : "memory"
    );
}

pub fn syscall2(number: SYS, arg1: usize, arg2: usize) usize {
    return asm volatile ("sc"
        : [ret] "={r3}" (-> usize)
        : [number] "{r0}" (@enumToInt(number)),
          [arg1] "{r3}" (arg1),
          [arg2] "{r4}" (arg2)
        : "memory"
    );
}

pub fn syscall3(number: SYS, arg1: usize, arg2: usize, arg3: usize) usize {
    return asm volatile ("sc"
        : [ret] "={r3}" (-> usize)
        : [number] "{r0}" (@enumToInt(number)),
          [arg1] "{r3}" (arg1),
          [arg2] "{r4}" (arg2),
          [arg3] "{r5}" (arg3)
        : "memory"
    );
}

pub fn syscall4(number: SYS, arg1: usize, arg2: usize, arg3: usize, arg4: usize) usize {
    return asm volatile ("sc"
        : [ret] "={r3}" (-> usize)
        : [number] "{r0}" (@enumToInt(number)),
          [arg1] "{r3}" (arg1),
          [arg2] "{r4}" (arg2),
          [arg3] "{r5}" (arg3),
          [arg4] "{r6}" (arg4)
        : "memory"
    );
}

pub fn syscall5(number: SYS, arg1: usize, arg2: usize, arg3: usize, arg4: usize, arg5: usize) usize {
    return asm volatile ("sc"
        : [ret] "={r3}" (-> usize)
        : [number] "{r0}" (@enumToInt(number)),
          [arg1] "{r3}" (arg1),
          [arg2] "{r4}" (arg2),
          [arg3] "{r5}" (arg3),
          [arg4] "{r6}" (arg4),
          [arg5] "{r7}" (arg5)
        : "memory"
    );
}

pub fn syscall6(
    number: SYS,
    arg1: usize,
    arg2: usize,
    arg3: usize,
    arg4: usize,
    arg5: usize,
    arg6: usize,
) usize {
    return asm volatile ("sc"
        : [ret] "={r3}" (-> usize)
        : [number] "{r0}" (@enumToInt(number)),
          [arg1] "{r3}" (arg1),
          [arg2] "{r4}" (arg2),
          [arg3] "{r5}" (arg3),
          [arg4] "{r6}" (arg4),
          [arg5] "{r7}" (arg5),
          [arg6] "{r8}" (arg6)
        : "memory"
    );
}

pub extern fn clone(func: fn (arg: usize) callconv(.C) u8, stack: usize, flags: u32, arg: usize, ptid: *i32, tls: usize, ctid: *i32) usize;

pub const restore = restore_rt;

pub fn restore_rt() callconv(.Naked) void {
    return asm volatile ("sc"
        :
        : [number] "{r0}" (@enumToInt(SYS.rt_sigreturn))
        : "memory"
    );
}
