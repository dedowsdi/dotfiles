alias val='valgrind --gen-suppressions=all --num-callers=40 --log-file=valgrind.log --error-limit=no'
alias valgl='val --suppressions=$HOME/.config/opengl.supp'
alias qt4d='LC_ALL=en_US.UTF-8 designer4'
alias go='gio open'
alias gpb='( { git push &>/tmp/gitpush_$(basename $(pwd))_$(date +"%T") || { tput setaf 1 ; tput bold ; echo push failed !!!!!!!!!!!!!!!! ; } ; } & )'
alias tt='pushd "$(mkt -p)"'
alias tb='nc termbin.com 9999'
alias vpr='CPP_BUILD_TYPE=Release vp'
alias vprd='CPP_BUILD_TYPE=RelWithDebInfo vp'
alias todo=todo-txt
alias ntoyf='ntoy --shadertoy --frag'
alias recenthistory='rh'
alias v='vim'
alias gdb='gdb -q'
alias g='git'
alias f='find'
alias f1='find . -mindepth 1 -maxdepth 1'
alias ta='tmux attach'
alias m=make
alias mm='make -j $(lscpu | grep -Po "^CPU\(s\).*\s*\K\d+")'

# grep text file, skip devices, binaries, repos
alias grept='grep --color=auto --binary-files=without-match --devices=skip --exclude-dir={.bzr,CVS,.git,.hg,.svn,.idea,.tox,.clangd}'
