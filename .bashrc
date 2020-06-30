
# If not running interactively, don't do anything
case $- in
  *i*) ;;
    *) return;;
esac

# Path to the bash it configuration
export BASH_IT="$HOME/.bash_it"
export BASH_IT_CUSTOM="$HOME/.dotfiles/.bash_it/custom"

# Lock and Load a custom theme file.
# Leave empty to disable theming.
# location /.bash_it/themes/
export BASH_IT_THEME='dedowsdi'

# (Advanced): Change this to the name of your remote repo if you
# cloned bash-it with a remote other than origin such as `bash-it`.
# export BASH_IT_REMOTE='bash-it'

# Your place for hosting Git repos. I use this for private repos.
export GIT_HOSTING='git@git.domain.com'

# Don't check mail when opening terminal.
unset MAILCHECK

# Change this to your console based IRC client of choice.
export IRC_CLIENT='wechat'

# Set this to the command you use for todo.txt-cli
export TODO="todo-txt"

# Set this to false to turn off version control status checking within the prompt for all themes
export SCM_CHECK=true

# Set Xterm/screen/Tmux title with only a short hostname.
# Uncomment this (or set SHORT_HOSTNAME to something else),
# Will otherwise fall back on $HOSTNAME.
#export SHORT_HOSTNAME=$(hostname -s)

# Set Xterm/screen/Tmux title with only a short username.
# Uncomment this (or set SHORT_USER to something else),
# Will otherwise fall back on $USER.
#export SHORT_USER=${USER:0:8

# Set Xterm/screen/Tmux title with shortened command and directory.
# Uncomment this to set.
#export SHORT_TERM_LINE=true

# Set vcprompt executable path for scm advance info in prompt (demula theme)
# https://github.com/djl/vcprompt
#export VCPROMPT_EXECUTABLE=~/.vcprompt/bin/vcprompt

# (Advanced): Uncomment this to make Bash-it reload itself automatically
# after enabling or disabling aliases, plugins, and completions.
# export BASH_IT_AUTOMATIC_RELOAD_AFTER_CONFIG_CHANGE=1

# Uncomment this to make Bash-it create alias reload.
# export BASH_IT_RELOAD_LEGACY=1

# personal stuff
shopt -s globstar
HISTSIZE=10000
HISTFILESIZE=20000

CDPATH=~/work
source ~/.commonrc
source ~/.bash_aliases

[[ -r ~/.dircolors ]] && eval "$(dircolors ~/.dircolors)"

if [[ "$TERM" == linux* ]]; then

    # solarized tty color, swap 0-8, 7-C
    echo -e "
      \e]P0002b36
      \e]P1dc322f
      \e]P2859900
      \e]P3b58900
      \e]P4268bd2
      \e]P5d33682
      \e]P62aa198
      \e]P7839496
      \e]P8073642
      \e]P9cb4b16
      \e]PA586e75
      \e]PBbf7600
      \e]PC3e64fb
      \e]PD6c71c4
      \e]PE009942
      \e]PFa39383
      "
    clear

    if [[ $(tty) == *[456] ]]; then
        TERM=linux-16color
    fi
else
    # gnome-terminal display crap if PS0 contain escape sequence.
    # you can't change cursor shape in terminal<--vim<--tmux
    # so I decide to only change cursor in plain x terminal emulator.
    if [[ -z $TMUX && -z $VTE_VERSION && $VIM_HOST_TERM != linux* ]]; then
        PS0='\[\e[2 q\]'
        INPUTRC=~/.urxvt_inputrc
    fi
fi

# Load Bash It
[[ -f "$BASH_IT"/bash_it.sh ]] && source "$BASH_IT"/bash_it.sh

TT=~/study/$(date +"%Y/%m/%d")
export TT

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
