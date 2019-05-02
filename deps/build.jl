##### Beginning of file

# Parts of this file are based on:
# 1. https://github.com/JuliaPackaging/Git.jl/blob/master/deps/build.jl

import Conda

function _default_git_cmd()::String
    result::String = lowercase(strip("git"))
    return result
end

function _default_gitlfs_cmd()::String
    result::String = lowercase(strip("git-lfs"))
    return result
end

function _found_default_git()::Bool
    default_git_cmd::String = _default_git_cmd()
    found_default_git::Bool = try
        success(`$(default_git_cmd) --version`)
    catch
        false
    end
    return found_default_git
end

function _found_default_gitlfs()::Bool
    default_gitlfs_cmd::String = _default_gitlfs_cmd()
    found_default_gitlfs::Bool = try
        success(`$(default_gitlfs_cmd) --version`)
    catch
        false
    end
    return found_default_gitlfs
end

function _install_git()::String
    result::String = _install_git_conda()
    return result
end

function _install_gitlfs()::String
    result::String = _install_gitlfs_conda()
    return result
end

function _install_git_conda()::String
    @info("Attempting to install git using Conda.jl...")
    environment::Symbol = :RemoveLFS
    Conda.add("git", environment)
    @info("Successfully installed git using Conda.jl.")
    git_cmd::String = strip(
        joinpath(
            Conda.bin_dir(environment),
            "git",
            )
        )
    run(`$(git_cmd) --version`)
    return git_cmd
end

function _install_gitlfs_conda()::String
    @info("Attempting to install git-lfs using Conda.jl...")
    environment::Symbol = :RemoveLFS
    Conda.add("git-lfs", environment)
    @info("Successfully installed git-lfs using Conda.jl.")
    gitlfs_cmd::String = strip(
        joinpath(
            Conda.bin_dir(environment),
            "git-lfs",
            )
        )
    run(`$(gitlfs_cmd) --version`)
    return gitlfs_cmd
end

function _build_git()::String
    install_git::Bool = lowercase(
        strip(get(ENV, "INSTALL_GIT", "false"))
        ) == lowercase(strip("true"))
    found_default_git::Bool = _found_default_git()
    if install_git
        @info("INSTALL_GIT is true, so I will now install git.")
        git_cmd = _install_git()
    elseif found_default_git
        @info("I found git on your system, so I will use that git.")
        git_cmd = _default_git_cmd()
    else
        @info("I did not find git on your system, so I will now install git.")
        git_cmd = _install_git()
    end
    return git_cmd
end

function _build_gitlfs()::String
    install_gitlfs::Bool = lowercase(
        strip(get(ENV, "INSTALL_GITLFS", "false"))
        ) == lowercase(strip("true"))
    found_default_gitlfs::Bool = _found_default_gitlfs()
    if install_gitlfs
        @info("INSTALL_GITLFS is true, so I will now install git-lfs.")
        gitlfs_cmd = _install_gitlfs()
    elseif found_default_gitlfs
        @info("I found git-lfs on your system, so I will use that git-lfs.")
        gitlfs_cmd = _default_gitlfs_cmd()
    else
        @info(
            string(
                "I did not find git-lfs on your system, ",
                "so I will now install git-lfs.",
                )
            )
        gitlfs_cmd = _install_gitlfs()
    end
    return gitlfs_cmd
end

function _build_organizationsnapshots()::Nothing
    git_cmd = _build_git()
    gitlfs_cmd = _build_gitlfs()
    build_jl_file_path = strip(
        abspath(
            strip(
                @__FILE__
                )
            )
        )
    @debug(
        "deps/build.jl: ",
        build_jl_file_path,
        )
    deps_directory = strip(
        abspath(
            strip(
                dirname(
                    strip(
                        build_jl_file_path
                        )
                    )
                )
            )
        )
    @debug(
        "deps:",
        deps_directory,
        )
    deps_jl_file_path = strip(
        abspath(
            joinpath(
                strip(deps_directory),
                strip("deps.jl"),
                )
            )
        )
    @debug(
        "deps/deps.jl:",
        deps_jl_file_path,
        )
    open(deps_jl_file_path, "w") do f
        line_1::String = "git_cmd = \"$(strip(string(git_cmd)))\""
        line_2::String = "gitlfs_cmd = \"$(strip(string(gitlfs_cmd)))\""
        @info("Writing line 1 to deps.jl: ", line_1,)
        println(f, line_1)
        @info("Writing line 2 to deps.jl: ", line_2,)
        println(f, line_2)
    end
    return nothing
end

_build_organizationsnapshots()

##### End of file
