"  _   _                         
" | |_| |__   ___ _ __ ___   ___ 
" | __| '_ \ / _ \ '_ ` _ \ / _ \
" | |_| | | |  __/ | | | | |  __/
"  \__|_| |_|\___|_| |_| |_|\___|
                               

" COLOR SCHEMES:
" -------------

set background=dark    " Setting dark mode
syntax on
set termguicolors      " True colors

" colorscheme candystripe, kolor, predawn, gruvbox, solarized, monokai, srcery, torte, onehalfdark...
" WIN
if has("win32")
  if has("gui_running")
    colorscheme solarized
  else
    " colors in windows console do not work very well
    colorscheme kolor
  endif
" MAC
elseif has ("mac")
  " let g:airline_theme='gruvbox'
  colorscheme onehalfdark
  let g:airline_theme='onehalfdark'
" LINUX
elseif has ("unix")
  if has("gui_running")
    colorscheme monokai
  else
    colorscheme gruvbox
    " let g:airline_theme='onehalfdark'
  endif
else
  colorscheme torte
endif
" Transparent backround
hi Normal guibg=None ctermbg=None

" FONT:
" -----

if has("gui_running")
  if has("gui_gtk2")
    set guifont=Inconsolata\ 12
  elseif has("gui_macvim")
    set guifont=Menlo\ Regular:h14
  elseif has("gui_win32")
    " set guifont=Consolas:h11:cANSI
    set guifont=Ubuntu\ Mono:h11:cANSI
  endif
endif

" GUI:
" Remove the scroll bars:
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" set cursorline
" set cursorcolumn
" highlight CursorLine ctermbg=Yellow cterm=bold guibg=#2b2b2b
" highlight CursorColumn ctermbg=Yellow cterm=bold guibg=#2b2b2b

" TWEAKS:
hi SignColumn guibg=None

" let s:N1   = [ '#00005f' , '#df0ff0' , 17  , 190 ]
" let s:N2   = [ '#ffffff' , '#444444' , 255 , 238 ]
" let s:N3   = [ '#9cffd3' , '#202020' , 85  , 234 ]
" let g:airline#themes#dark_minimal#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
let g:airline#themes#dark_minimal#palette.normal = airline#themes#generate_color_map([ '#00005f' , '#df0ff0' , 17  , 190 ], [ '#ffffff' , '#444444' , 255 , 238 ], [ '#9cffd3' , '#202020' , 85  , 234 ])
