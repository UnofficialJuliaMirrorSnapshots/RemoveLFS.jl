##### Beginning of file

module Hosts # Begin submodule RemoveLFS.Hosts

__precompile__(true)

import ..Types
import ..Utils

import ..delayederror

include(joinpath("BitbucketDstHost", "BitbucketDstHost.jl"))

include(joinpath("GitHubDstHost", "GitHubDstHost.jl"))

include(joinpath("GitLabDstHost", "GitLabDstHost.jl"))

end # End submodule RemoveLFS.Hosts

##### End of file
