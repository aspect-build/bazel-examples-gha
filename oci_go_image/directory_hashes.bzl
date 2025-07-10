"""Rule for generating integrity files

Default output is a .sha256 file but .sha1 and .md5 files are also available
via output groups.

Based on https://github.com/bazelbuild/examples/blob/main/rules/implicit_output/hash.bzl
"""

def _hash_directory(ctx, algo, dir):
    coreutils = ctx.toolchains["@aspect_bazel_lib//lib:coreutils_toolchain_type"]
    out = ctx.actions.declare_file("{}.{}".format(dir.basename, algo), sibling = dir)
    ctx.actions.run_shell(
        outputs = [out],
        inputs = [dir],
        tools = [coreutils.coreutils_info.bin],
        # coreutils has --no-names option but it doesn't work in current version, so we have to use cut.
        command = """find {src} -type l,f -exec {coreutils} hashsum --{algo} {{}} \\; > {out}""".format(
            coreutils = coreutils.coreutils_info.bin.path,
            algo = algo,
            src = dir.path,
            basename = dir.basename,
            out = out.path,
        ),
        toolchain = "@aspect_bazel_lib//lib:coreutils_toolchain_type",
    )
    return out

def _directory_hashes_impl(ctx):
    # Create actions to generate the three output files.
    # Actions are run only when the corresponding file is requested.

    if not ctx.file.src.is_directory:
        fail("src is expected to be a directory input")

    md5out = _hash_directory(ctx, "md5", ctx.file.src)
    sha1out = _hash_directory(ctx, "sha1", ctx.file.src)
    sha256out = _hash_directory(ctx, "sha256", ctx.file.src)

    # By default (if you run `bazel build` on this target, or if you use it as a
    # source of another target), only the sha256 is computed.
    return [
        DefaultInfo(
            files = depset([sha256out]),
        ),
        OutputGroupInfo(
            md5 = depset([md5out]),
            sha1 = depset([sha1out]),
            sha256 = depset([sha256out]),
        ),
    ]

_directory_hashes = rule(
    implementation = _directory_hashes_impl,
    toolchains = [
        "@aspect_bazel_lib//lib:coreutils_toolchain_type",
    ],
    attrs = {
        "src": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
    },
)

def directory_hashes(name, src, **kwargs):
    _directory_hashes(
        name = name,
        src = src,
        **kwargs
    )
