import HTTP
import Pkg

const GIT_LFS_REPOS_TOML_FILE_URL = "https://raw.githubusercontent.com/UnofficialJuliaMirror/MirrorUpdater.jl/master/config/repositories/git-lfs-repos-src-dest-pairs.toml"

const GIT_LFS_REPOS = Pkg.TOML.parse(
    String(HTTP.request("GET", GIT_LFS_REPOS_TOML_FILE_URL).body)
    )
