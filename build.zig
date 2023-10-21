const std = @import("std");

const Build = std.Build;

pub fn installHeaders(
    b: *Build,
    compile: *Build.Step.Compile,
    source: Build.LazyPath,
    destination: []const u8,
) void {
    const install_file = Build.Step.InstallFile.create(
        b,
        source.dupe(b),
        .header,
        destination,
    );
    b.getInstallStep().dependOn(&install_file.step);
    compile.installed_headers.append(&install_file.step) catch @panic("OOM");
}

pub fn getInstallRelativePath(
    b: *Build,
    other: *Build.Step.Compile,
    to: []const u8,
) Build.LazyPath {
    const generated = b.allocator.create(Build.GeneratedFile) catch @panic("OOM");
    generated.step = &other.step;
    generated.path = b.pathJoin(&.{ other.step.owner.install_path, to });
    return .{ .generated = generated };
}
