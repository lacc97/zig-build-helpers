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
