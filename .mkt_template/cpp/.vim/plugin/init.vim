function s:make()
  CloseFinishedTerminal
  bot ter make
  wincmd p
endfunction

function s:run()
  CloseFinishedTerminal
  bot ter ./build/a.out
  wincmd p
endfunction

nnoremap <f7> :call <sid>make()<cr>
nnoremap <f5> :call <sid>run()<cr>
silent e a.cpp
/main/++
