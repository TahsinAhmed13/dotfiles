#
# /etc/bash.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# ALIASES
alias ls="ls --color --group-directories-first --human-readable"
alias grep="grep --color --line-number"
alias cat="cat -n"
alias less="less -R -N"
alias h="history"
alias hc="cat /dev/null > $HOME/.bash_history"
alias config="git --git-dir=$HOME/.dotfiles --work-tree=$HOME"

for cmd in cp rm; do
    alias $cmd="$cmd -i -r"
done

for cmd in pacman mount umount su; do
    alias $cmd="sudo $cmd"
done

# GIT
function get_git_commits()
{
    remote=$1
    branch=$2

    # local branch does not exist
    [ -z "$(git rev-parse --verify $branch 2> /dev/null)" ] && return 1
    # remote branch does not exist
    [ -z "$(git rev-parse --verify $remote/$branch 2> /dev/null)" ] && return 2

    # compare local branch vs. remote branch
    ahead=$(git rev-list $branch --not --count $remote/$branch)
    [ $ahead -ne 0 ] && printf "%s" "↑$ahead"

    # compare remote branch vs. local branch
    behind=$(git rev-list $remote/$branch --not --count $branch)
    [ $behind -ne 0 ] && printf "%s" "↓$behind"
}

function get_git_prompt()
{
    # check for git repos
    git status > /dev/null 2>&1
    if [ $? -eq 0 ]; then 
        remote=$(git remote show)
        branch=$(git branch --show-current)

        printf " ("
        printf "$branch"
        printf "$(get_git_commits $remote $branch)"
        printf ")"
    fi
}

# PROMPTS
PS1='\n[\u@\h \W$(get_git_prompt)]\n '
