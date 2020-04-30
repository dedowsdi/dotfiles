alias val='valgrind --gen-suppressions=all --num-callers=40 --log-file=valgrind.txt --error-limit=no'
alias valgl='val --suppressions=$HOME/.config/opengl.supp'
alias qt4d='LC_ALL=en_US.UTF-8 designer4'
alias go=gio open
alias vless="vim -R -"
alias svim='sudo -E vim --cmd "set modeline"'
alias gpb='( { git push &>/tmp/gitpush_$(basename $(pwd))_$(date +"%T") || { tput setaf 1 ; tput bold ; echo push failed !!!!!!!!!!!!!!!! ; } ; } & )'
alias dvim='GIT_DIR="$HOME/.dotfiles" GIT_WORK_TREE="$HOME" vim'
alias dgit='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias dgitdirstatus='dgit status -unormal $( dgit ls-tree -d -r master --name-only ) '
alias tt='cd "$(mkt -p)"'
alias tb='nc termbin.com 9999'
alias vpr='CPP_BUILD_TYPE=Release vp'
alias vprd='CPP_BUILD_TYPE=RelWithDebInfo vp'
alias todo=todo-txt
alias ntoyf='ntoy --shadertoy --frag'

# quite gdb
alias gdb='gdb -q'

alias grep='grep --color=auto --binary-files=without-match --devices=skip --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.clangd}'

# alias info="info --vi-keys"
