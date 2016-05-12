#!/bin/bash
script=script
vim=nvim
session=
pjvim=

if [[ -a $script/session.vim ]]; then
    session=" -S $script/session.vim"
fi
if [[ -a $script/pj.vim ]]; then
    pjvim=" -S $script/pj.vim"
fi


$vim $session $pjvim
