# at most 1 subshells.

# uncomment this if you want to see user@host
# show_user_host=

# require colors.theme.bash
start_seq="$cyan"
false_seq="$bold_red"
git_seq="$purple"
end_seq="$purple"
wd_seq="$bold_cyan"
user_seq="$blue"
sgr0="$normal"

# no sub shell if GIT_BRANCH exists
___dedowsdi_ps()
{
    exit_code=$?
    local start_symbol user_host workding_dir git_branch end_symbol

    # change color, show exit code upon error
    if [[ $exit_code == 0 ]] ; then
        printf -v start_symbol "$start_seq-->"
        printf -v end_symbol " $end_seq\u2717$sgr0"
    else
        printf -v start_symbol "$false_seq-->[%s]" "$exit_code"
        printf -v end_symbol " $false_seq\u2717$sgr0"
    fi

    # show user@host only if show_user_host exist
    if [[ -v show_user_host ]]; then
        printf -v user_host " $user_seq%s@%s:" "$USER" "$HOSTNAME"
    fi

    # show last 2 parts of working directory, always use ~ for home
    workding_dir="${PWD#${HOME}}"
    if [[ "$workding_dir" != "$PWD" ]]; then
        workding_dir="~$workding_dir"
    fi

    local head="${workding_dir%/*/*}"
    if [[ "$head" != "$workding_dir" && -n "$head" ]]; then
        workding_dir="${workding_dir#${head}/}"
    fi
    printf -v workding_dir " $wd_seq%s" "$workding_dir"

    # use GIT_BRANCH to avoid subshell if POSSIBLE
    if [[ -v GIT_BRANCH ]]; then
        git_branch="$GIT_BRANCH"
    else
        git_branch="$(_git-branch)"
    fi
    if [[ -n "$git_branch" ]]; then
        printf -v git_branch " $git_seq(%s)" "$git_branch"
    fi

    printf -v PS1 '%s%s%s%s%s ' \
        "$start_symbol" "$user_host" "$workding_dir" "$git_branch" "$end_symbol"
}

PROMPT_COMMAND='___dedowsdi_ps'
