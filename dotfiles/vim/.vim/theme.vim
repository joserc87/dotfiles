"  _   _                         
" | |_| |__   ___ _ __ ___   ___ 
" | __| '_ \ / _ \ '_ ` _ \ / _ \
" | |_| | | |  __/ | | | | |  __/
"  \__|_| |_|\___|_| |_| |_|\___|
                               

" COLOR SCHEMES:
" -------------

" set background=dark    " Setting dark mode
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
    colorscheme gruvbox-material
    let g:gruvbox_contrast_dark='medium'
    let g:gruvbox_contrast_light='medium'
    " colorscheme solarized
    let g:airline_theme='gruvbox'

    " let g:airline_theme='onehalfdark'
    let g:airline_theme='gruvbox_material'
    "
    let g:gruvbox_material_palette = 'original'
    " let g:gruvbox_material_background = 'hard'
    " let g:gruvbox_material_background = 'medium'

    colorscheme gruvbox-material
  endif
else
  colorscheme torte
endif
" Transparent backround
" hi Normal guibg=None ctermbg=None
hi Normal ctermbg=None

" FONT:
" -----

if exists('g:neovide') || has('gui_running')
  " set guifont=NotoSansMono\ Nerd\ Font
  set guifont=NotoSansMono\ Nerd\ Font:h8,Noto\ Emoji:h26,Noto\ Color\ Emoji:h26,DejaVu\ Sans\ Mono:h26
  " set guifont=Terminess\ TTF\ Nerd\ Font\ Mono:26;Noto\ Emoji:h26,Noto\ Color\ Emoji:h26,DejaVu\ Sans\ Mono:h26
  " if has("gui_gtk2")
  "   set guifont=Inconsolata\ 12
  " elseif has("gui_macvim")
  "   set guifont=Menlo\ Regular:h14
  " elseif has("gui_win32")
  "   " set guifont=Consolas:h11:cANSI
  "   set guifont=Ubuntu\ Mono:h11:cANSI
  " endif
endif

" GUI:
" Remove the scroll bars:
set guioptions-=r
set guioptions-=R
set guioptions-=l
set guioptions-=L

" TWEAKS:

" set cursorline
" set cursorcolumn
" highlight CursorLine ctermbg=Yellow cterm=bold guibg=#2b2b2b
" highlight CursorColumn ctermbg=Yellow cterm=bold guibg=#2b2b2b
" highlight VertSplit ctermbg=Black guibg=#1C1C1C guifg=#1C1C1C
" highlight VertSplit ctermbg=none guibg=none guifg=none
highlight VertSplit ctermbg=Black guibg=#323030 guifg=#323030
set fillchars+=vert:\ 
" highlight LineNr ctermbg=Black guibg=None guifg=#FABD2F
highlight CursorLineNr ctermbg=Black guibg=None guifg=#FABD2F

hi SignColumn guibg=None
set signcolumn=auto
set foldcolumn=0

" let s:N1   = [ '#00005f' , '#df0ff0' , 17  , 190 ]
" let s:N2   = [ '#ffffff' , '#444444' , 255 , 238 ]
" let s:N3   = [ '#9cffd3' , '#202020' , 85  , 234 ]
" let g:airline#themes#dark_minimal#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)
" let g:airline#themes#dark_minimal#palette.normal = airline#themes#generate_color_map([ '#00005f' , '#df0ff0' , 17  , 190 ], [ '#ffffff' , '#444444' , 255 , 238 ], [ '#9cffd3' , '#202020' , 85  , 234 ])

" VIMWIKI:
" -------
"
highlight VimwikiHeader1 gui=bold guifg=#FB4934 cterm=bold ctermfg=9
highlight VimwikiHeader2 gui=bold guifg=#FABD2F cterm=bold ctermfg=11
highlight VimwikiHeader3 gui=bold guifg=#FE8019 cterm=bold ctermfg=2
highlight VimwikiHeader4 gui=bold guifg=#B16286 cterm=bold ctermfg=5
highlight VimwikiHeader5 gui=bold guifg=#458588 cterm=bold ctermfg=6
highlight VimwikiHeader6 gui=bold guifg=#689D6A cterm=bold ctermfg=4

highlight Floaterm guibg=none
highlight FloatermBorder guibg=none guifg=orchid
