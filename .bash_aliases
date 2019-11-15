alias glvalgrind='valgrind --gen-suppressions=all --leak-check=full --num-callers=40 --log-file=valgrind.txt --suppressions=/home/pntandcnt/.config/opengl.supp  --suppressions=/home/pntandcnt/.config/osg.supp  --error-limit=no -v'
alias qt4d='LC_ALL=en_US.UTF-8 designer4'
alias go=gvfs-open
alias cdstackexchange='cd ~/stackexchange/$(date +%Y/%m/%d)'
alias vless="vim -Rnu ~/.less.vimrc -"
alias svim='sudo -E vim --cmd "set modeline"'
alias gpb='( { git push &>/tmp/gitpush_$(basename $(pwd))_$(date +"%T") || { tput setaf 1 ; tput bold ; echo push failed !!!!!!!!!!!!!!!! ; } ; } & )'
alias dvim='GIT_DIR="$HOME/.dotfiles" GIT_WORK_TREE="$HOME" vim'
alias dgit='git --git-dir=$HOME/.dotfiles --work-tree=$HOME'
alias dgitdirstatus='dgit status -unormal $( dgit ls-tree -d -r master --name-only ) '

# you can not use --exclude and --include together, the later one will be simply ignored
# alias grep='grep -I --exclude-dir={.git,.hg} --exclude={.*.swp}'

# alias info="info --vi-keys"
