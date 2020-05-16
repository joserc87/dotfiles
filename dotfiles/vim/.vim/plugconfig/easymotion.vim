"                                       _   _             
"   ___  __ _ ___ _   _ _ __ ___   ___ | |_(_) ___  _ __  
"  / _ \/ _` / __| | | | '_ ` _ \ / _ \| __| |/ _ \| '_ \ 
" |  __/ (_| \__ \ |_| | | | | | | (_) | |_| | (_) | | | |
"  \___|\__,_|___/\__, |_| |_| |_|\___/ \__|_|\___/|_| |_|
"                 |___/                                   
"
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

" For navigation \s{char}{label}
map <leader>s <Plug>(easymotion-s)
" OR for \s{char}{char}{label}
" map <leader>s <Plug>(easymotion-s2)

map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)
nmap s <Plug>(easymotion-overwin-f2)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
