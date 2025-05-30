const std = @import("std");

pub fn gcd(a: anytype, b: anytype) @TypeOf(a, b) {
    comptime switch (@typeInfo(@TypeOf(a, b))) {
        .int => |int| std.debug.assert(int.signedness == .unsigned),
        .comptime_int => {
            std.debug.assert(a >= 0);
            std.debug.assert(b >= 0);
        },
        else => unreachable,
    };
    std.debug.assert(a != 0 or b != 0);

    if (a == 0) return b;
    if (b == 0) return a;

    var x: @TypeOf(a, b) = a;
    var y: @TypeOf(a, b) = b;
    var m: @TypeOf(a, b) = a;

    while (y != 0) {
        m = x % y;
        x = y;
        y = m;
    }
    return x;
}

test "gcd" {
    const expectEqual = std.testing.expectEqual;

    try expectEqual(gcd(0, 5), 5);
    try expectEqual(gcd(5, 0), 5);
    try expectEqual(gcd(8, 12), 4);
    try expectEqual(gcd(12, 8), 4);
    try expectEqual(gcd(33, 77), 11);
    try expectEqual(gcd(77, 33), 11);
    try expectEqual(gcd(49865, 69811), 9973);
    try expectEqual(gcd(300_000, 2_300_000), 100_000);
    try expectEqual(gcd(90000000_000_000_000_000_000, 2), 2);
}
