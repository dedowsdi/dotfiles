function s:make()
  CloseFinishedTerminal
  bot ter make
  wincmd p
endfunction

function s:run()
  CloseFinishedTerminal
  bot ter bash -c "make && ./build/a.out"
  wincmd p
endfunction

set splitbelow
nnoremap <f7> :call <sid>make()<cr>
nnoremap <f5> :call <sid>run()<cr>
