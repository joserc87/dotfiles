" Run macro on lines:
xnoremap @ :<C-u>call ExecuteMacroOverVisualRange()<CR>

function! ExecuteMacroOverVisualRange()
  echo "@".getcmdline()
    execute ":'<,'>normal @".nr2char(getchar())
endfunction

" Notes:
" cgn + dot can replace some simple macros

" Paste a common macro here
" with "xp where x is the register of a macro
" then let @x = 'yourmacro'


let @/ = '\s\+$'
let @s = 'cgn<ESC>'
