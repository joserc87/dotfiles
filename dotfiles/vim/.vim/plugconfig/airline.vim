" AIRLINE:
" -------
" Smarter tab line for airline:
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
" let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#formatter = 'unique_tail'
" automatically populate the g:airline_symbols
let g:airline_powerline_fonts = 0
let g:airline_theme='dark'
let s:section_truncate_width = get(g:, 'airline#extensions#default#section_truncate_width', {
      \ 'z': 110,
      \ 'b': 120,
      \ 'x': 100,
      \ 'y': 120,
      \ 'warning': 80,
      \ 'error': 80,
      \ })
let s:layout = get(g:, 'airline#extensions#default#layout', [
      \ [ 'a', 'c' ],
      \ [ 'x', 'y', 'z', 'warning', 'error' ]
      \ ])
