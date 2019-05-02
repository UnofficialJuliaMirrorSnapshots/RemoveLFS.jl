##### Beginning of file

module Run # Begin submodule RemoveLFS.Run

__precompile__(true)

import ArgParse
import Dates
import HTTP
import Pkg
import TimeZones

import ..Types
import ..Utils
import ..Common

import ..delayederror
import ..process_delayed_error_list

function run_removelfs_snapshots!!(
        ;
        git_lfs_repos::AbstractDict,
        dst_provider,
        git_user_name,
        git_user_email,
        include_branches,
        exclude_branches,
        task::String = "all",
        is_dry_run::Bool = false,
        do_not_push_to_these_destinations::Vector{String} =
            String[],
        do_not_try_url_list::Vector{String} =
            String[],
        try_but_allow_failures_url_list::Vector{String} =
            String[],
        time_zone::Dates.TimeZone =
            Dates.TimeZone("America/New_York"),
        )::Nothing
    @info("Running RemoveLFS.Run.run_removelfs_snapshots!!")

    all_src_dest_pairs::Vector{Types.SrcDestPair} = Types.SrcDestPair[
        Types.SrcDestPair(
            ;
            source_url = x["source_url"],
            destination_repo_name = x["destination_repo_name"],
            ) for x in values(git_lfs_repos)
        ]
    sort!(all_src_dest_pairs)
    unique!(all_src_dest_pairs)
    sort!(all_src_dest_pairs)

    @debug(
        string(
            "All source URLs in the list ",
            "($(length(all_src_dest_pairs))):",
            )
        )
    for i = 1:length(all_src_dest_pairs)
        @debug(
            "$(i). $(all_src_dest_pairs[i].source_url)"
            )
    end

    if task == "all"
        task_src_dest_pairs = all_src_dest_pairs
    elseif Types._is_interval(task)
        task_interval::Types.AbstractInterval = Types._construct_interval(
            task
            )
        @info(string("Using interval: "),task_interval,)
        task_src_dest_pairs = Common._pairs_that_fall_in_interval(
            all_src_dest_pairs,
            task_interval,
            )
    else
        @warn("not a valid task: ", task,)
        delayederror("\"$(task)\" is not a valid task")
    end

    unique!(task_src_dest_pairs)
    sort!(task_src_dest_pairs)
    @debug(
        string(
            "Source URLs in the task interval ",
            "($(length(task_src_dest_pairs))):",
            )
        )
    for i = 1:length(task_src_dest_pairs)
        @debug(
            "$(i). $(task_src_dest_pairs[i].source_url)"
            )
    end

    n = length(task_src_dest_pairs)
    for i = 1:n
        pair = task_src_dest_pairs[i]
        source_url = pair.source_url
        destination_repo_name = pair.destination_repo_name
        @debug(
            string(
                "Processing \"$(source_url)\" ",
                "(URL $(i) of $(n))",
                )
            )
        if false
        else
            if destination_repo_name in do_not_push_to_these_destinations
            else
                Common._snapshot_repo!!(
                    pair;
                    dst_provider = dst_provider,
                    include_branches = include_branches,
                    exclude_branches = exclude_branches,
                    git_user_name = git_user_name,
                    git_user_email = git_user_email,
                    time_zone = time_zone,
                    is_dry_run = is_dry_run,
                    )
            end
        end
    end

    @info(
        string(
            "SUCCESS: run_removelfs_snapshots completed ",
            "successfully :) Good-bye!",
            )
        )

    process_delayed_error_list()
    return nothing
end

end # End submodule RemoveLFS.Run

##### End of file
