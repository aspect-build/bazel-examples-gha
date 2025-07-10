load("@aspect_bazel_lib//lib:expand_make_vars.bzl", "expand_variables")

def _gha_delivery_trigger_impl(ctx):
    if ctx.file.hash.is_directory:
        fail("src is expected to be a file input")


    executable = ctx.actions.declare_file("gha_delivery_trigger_%s.sh" % ctx.label.name)
    files = [ctx.file.hash]

    envs = {
        "ASPECT_WORKFLOWS_DELIVERY_REPOSITORY": ctx.attr.repository,
        "ASPECT_WORKFLOWS_DELIVERY_WORKFLOW": ctx.attr.workflow,
        "ASPECT_WORKFLOWS_DELIVERY_TARGET": ctx.attr.target,

    }
    inherited_envs = [
        ctx.attr.github_sha_env,
        ctx.attr.github_token_env,
        ctx.attr.github_ref_name_env,
    ]

    ctx.actions.expand_template(
        template = ctx.file._gha_delivery_trigger_sh_tpl,
        output = executable,
        is_executable = True,
        substitutions = {
            "GITHUB_SHA_ENV": ctx.attr.github_sha_env,
            "GITHUB_TOKEN_ENV": ctx.attr.github_token_env,
            "GITHUB_REF_NAME_ENV": ctx.attr.github_ref_name_env,
        },
    )
    runfiles = ctx.runfiles(files = files)

    return [
        DefaultInfo(
            executable = executable,
            runfiles = runfiles,
        ),
        RunEnvironmentInfo(
            environment = envs,
            inherited_environment = inherited_envs
        )
    ]

_gha_delivery_trigger = rule(
    implementation = _gha_delivery_trigger_impl,
    attrs = {
        "hash": attr.label(
            allow_single_file = True,
            mandatory = True,
        ),
        "target": attr.string(
            mandatory = True,
        ),
        "repository": attr.string(
            mandatory = True,
        ),
        "workflow": attr.string(
            mandatory = True,
        ),
        "github_sha_env": attr.string(
            default = "GITHUB_SHA",
        ),
        "github_ref_name_env": attr.string(
            default = "GITHUB_REF_NAME"
        ),
        "github_token_env": attr.string(
            default = "GITHUB_TOKEN",
        ),
        "env": attr.string_dict(),
        "_gha_delivery_trigger_sh_tpl": attr.label(
            default = "gha_delivery_trigger.sh.tpl",
            allow_single_file = True,
        ),
    },
    executable = True,
)

def gha_delivery_trigger(name, **kwargs):
    _gha_delivery_trigger(
        name = name,
        **kwargs
    )
