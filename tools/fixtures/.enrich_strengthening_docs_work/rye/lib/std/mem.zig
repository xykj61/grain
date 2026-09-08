pub fn eql(comptime T: type, a: []const T, b: []const T) bool {
    return a.len == b.len;
}
