" NERDTREE:
" --------
nnoremap <leader>ne :NERDTreeFocus<CR>
nnoremap <leader>nf :NERDTreeFind<CR>
nnoremap <leader>nn :NERDTreeToggle<CR>

let g:NERDTreeDirArrowExpandable = ''
let g:NERDTreeDirArrowCollapsible = ''
" let g:NERDTreeDirArrowExpandable = '▸'
" let g:NERDTreeDirArrowCollapsible = '▾'

let NERDTreeQuitOnOpen=1
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
let NERDTreeIgnore=['__pycache__', '\.pytest_cache', '\.idea', '\.pyc$', '\~$']
" NERDTress File highlighting
""" function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
"""     exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
"""     exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s+.*'. a:extension .'$#'
""" endfunction
"""
""" call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
""" call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
""" call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
""" call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
""" call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
""" call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
""" call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
""" call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
""" call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
""" call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
""" call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
""" call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
""" call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
""" call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', '#151515')
""" call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868', '#151515')
""" call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868', '#151515')
""" call NERDTreeHighlightFile('bashrc', 'Gray', 'none', '#686868', '#151515')
""" call NERDTreeHighlightFile('bashprofile', 'Gray', 'none', '#686868', '#151515')
""" "Note: If the colors still are not highlighting, try invoking such as:
""" "autocmd VimEnter * call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515') 
" let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1
let g:NERDTreeSortOrder = ['/$', '\.py$', '\.json$', '\.(js|jsx|ts|tsx)$', '\.html$',  '\.sql$', '\.sh$', '\.(c|cpp)$', '\.h$', '*', '\.cfg$', '\.ini$', '\.md$', 'Dockerfile$', '\.txt$', ]
"
" you can add these colors to your .vimrc to help customizing
let s:brown = "905532"
let s:aqua =  "3AFFDB"
let s:blue = "689FB6"
let s:dockerBlue = "0DB7ED"
let s:darkBlue = "44788E"
let s:pythonBlue = "4584B6"
let s:pythonYellow = "FFD43B"
let s:purple = "834F79"
let s:lightPurple = "834F79"
let s:red = "AE403F"
let s:beige = "F5C06F"
let s:yellow = "F09F17"
let s:orange = "D4843E"
let s:darkOrange = "F16529"
let s:pink = "CB6F6F"
let s:salmon = "EE6E73"
let s:green = "8FAA54"
let s:lightGreen = "31B53E"
let s:white = "FFFFFF"
let s:rspec_red = 'FE405F'
let s:git_orange = 'F54D27'

let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
let g:NERDTreeExtensionHighlightColor['py'] = s:pythonBlue " sets the color of css files to blue
let g:NERDTreeExtensionHighlightColor['Dockerfile'] = s:dockerBlue " sets the color of css files to blue
let g:WebDevIconsDefaultFolderSymbolColor = s:beige " sets the color for folders that did not match any rule
let g:WebDevIconsDefaultFileSymbolColor = s:blue
let g:DevIconsEnableFoldersOpenClose = 1 "Enables different glyphs for open and closed folders
highlight NERDTreeDir guifg=s:beige guibg=NONE
" call NERDTreeHighlightFile('NERDTreeDir', '#' . s:beige, 'none', '#' . s:beige, 0)
" call NERDTreeHighlightFile('NERDTreeDirSlash', '#' . s:beige, 'none', 'white', 'black')
autocmd FileType nerdtree highlight NERDTreeDir guifg=none ctermfg=none guibg=NONE ctermbg=NONE
autocmd FileType nerdtree highlight NERDTreeDirSlash guifg=none ctermfg=none guibg=NONE ctermbg=NONE
