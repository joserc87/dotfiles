-- [[ Basic Keymaps ]]

-- Map ; to : so we don't have to press shift
vim.keymap.set({ 'n', 'v' }, ';', ':', {})
vim.keymap.set({ 'n', 'v' }, ':', ';', {})

-- jj goes to normal mode
vim.keymap.set({ 'i' }, 'jj', '<Esc>', { desc = '[jj] Go to normal mode' })

-- Sensible Y. For old Y, just do yy!
vim.keymap.set({ 'n' }, 'Y', 'y$')
vim.keymap.set({ 'n' }, 'y%', ':let @" = expand("%") . ":" . line(".")<CR>')
vim.keymap.set({ 'v' }, '+', '"+y')
vim.keymap.set({ 'n' }, '+', '"+p')

-- By pressing C-c after {, it will put the pointer in the line between { and }
vim.keymap.set({ 'i' }, '<C-c>', '<CR><Esc>O')

-- Execute line under cursor
vim.keymap.set({ 'n' }, '<leader>x', ':exe getline(\'.\')<CR>')

-- Move blocks of code
vim.keymap.set({ 'v' }, '<C-M-J>', ':m \'>+1<CR>gv=gv')
vim.keymap.set({ 'v' }, '<C-M-K>', ':m \'<-2<CR>gv=gv')

-- Change occurences
vim.keymap.set({ 'n' }, 'cn', '*``cgn')
vim.keymap.set({ 'n' }, 'cN', '*``cgN')

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- NAVIGATION:
-- WINDOW
-- This is done with tmux navigation
-- nnoremap <C-J> <C-W><C-J>
-- nnoremap <C-K> <C-W><C-K>
-- nnoremap <C-L> <C-W><C-L>
-- nnoremap <C-H> <C-W><C-H>
vim.keymap.set({ 'n' }, '<C-J>', ':TmuxNavigateDown<CR>')
vim.keymap.set({ 'n' }, '<C-K>', ':TmuxNavigateUp<CR>')
vim.keymap.set({ 'n' }, '<C-L>', ':TmuxNavigateRight<CR>')
vim.keymap.set({ 'n' }, '<C-H>', ':TmuxNavigateLeft<CR>')
-- BUFFER
vim.keymap.set({ 'n' }, '<leader>bl', ':bnext<CR>')
vim.keymap.set({ 'n' }, '<leader>bh', ':bprevious<CR>')
vim.keymap.set({ 'n' }, '<leader>bq', ':bp <BAR> bd #<CR>')
-- nnoremap <M-j> :tabnext<CR>
-- nnoremap <M-k> :tabprevious<CR>
vim.keymap.set({ 'n' }, '<M-l>', ':bnext<CR>')
vim.keymap.set({ 'n' }, '<M-h>', ':bprevious<CR>')
vim.keymap.set({ 'n' }, '<M-q>', ':bp <BAR> bd #<CR>')
-- nnoremap <backspace> <C-^>
-- QUICKFIX
vim.keymap.set({ 'n' }, '<leader>cc', ':copen<CR>')
vim.keymap.set({ 'n' }, '<leader>cl', ':cn<CR>')
vim.keymap.set({ 'n' }, '<leader>ch', ':cp<CR>')
vim.keymap.set({ 'n' }, '<leader>cq', ':cclose<CR>')
--nmap <leader>bl :ls<CR> " Show all open buffers and their status
-- TAB
vim.keymap.set({ 'n' }, 'th', ':tabfirst<CR>')
vim.keymap.set({ 'n' }, 'tj', ':tabnext<CR>')
vim.keymap.set({ 'n' }, 'tk', ':tabprev<CR>')
vim.keymap.set({ 'n' }, 'tl', ':tablast<CR>')
vim.keymap.set({ 'n' }, 'tt', ':tabnew<CR>')
vim.keymap.set({ 'n' }, 'tn', ':tabnext<Space>')
vim.keymap.set({ 'n' }, 'tm', ':tabm<Space>')
vim.keymap.set({ 'n' }, 'tq', ':tabclose<CR>')
vim.keymap.set({ 'n' }, '<leader>m',  ':silent! TZNarrow<CR>')
vim.keymap.set({ 'n' }, '<leader>zn', ':silent! TZNarrow<CR>', {})
vim.keymap.set({ 'v' }, '<leader>zn', "'<,'>TZNarrow<CR>", {})
vim.keymap.set({ 'n' }, '<leader>zf', ':silent! TZFocus<CR>', {})
vim.keymap.set({ 'n' }, '<leader>zm', ':silent! TZMinimalist<CR>', {})
vim.keymap.set({ 'n' }, '<leader>za', ':silent! TZAtaraxis<CR>', {})


-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><leader>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })
vim.keymap.set('v', '<leader>/', '"zy:Telescope live_grep default_text=<C-r>z<cr>')
vim.keymap.set('n', '<leader>s', ':Telescope<CR>', { desc = '[S]earch telescope command' })
vim.keymap.set('n', '<C-p>', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope').extensions.live_grep_args.live_grep_args,
  { desc = '[S]earch by [G]rep' })
--vim.keymap.set('n', '<leader>sg', function()
--  require('telescope.builtin').grep_string({ shorten_path = true, word_match = "-w", only_sort_text = true, search = '' })
--end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>st', function()
  dirs = {"~/code/braindump/brain/diary", "~/code/braindump/brain/ravenpack"}
  require("telescope").extensions.live_grep_args.live_grep_args({default_text="\\- \\[ \\]", search_dirs=dirs})
end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sb', require('telescope.builtin').buffers, { desc = '[S]earch [B]uffers' })
vim.keymap.set('n', '<leader>sv', function()
  require('telescope.builtin').find_files({ search_dirs = { '~/code/dotfiles/linux/.config/nvim/', '~/.vim/' } })
end, { desc = '[S]earch [V]im config files' })
vim.keymap.set('n', '<leader>ss', function()
  require('telescope.builtin').find_files({ search_dirs = { '~/code/dotfiles/scripts/' } })
end, { desc = '[S]earch [S]scripts' })
vim.keymap.set('n', '<leader>p', require('telescope.builtin').git_status, { desc = 'bad naming. Change me' })
vim.keymap.set('n', '<leader>;', require('telescope.builtin').commands, { desc = 'Search Commands' })
vim.keymap.set('n', '<leader>:', require('telescope.builtin').command_history, { desc = 'Search Command History' })

-- Diagnosic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- FLOATERM:
vim.keymap.set('n', '<leader>fz', ':FloatermNew fzf --preview \'~/.vim/plugged/fzf.vim/bin/preview.sh {}\'<CR>')
vim.keymap.set('n', '<leader>fs', ':FloatermNew zsh<CR>')
vim.keymap.set('n', '<leader>fr', ':FloatermNew ranger<CR>')
vim.keymap.set('n', '<leader>fp', ':FloatermNew  --wintype=normal --position=right --width=0.4 ipython<CR>')
vim.keymap.set('n', '<leader>fP', ':FloatermNew  --wintype=normal --position=right --width=0.4 python<CR>')
-- vim.keymap.set('n', '<leader>fg', ':FloatermNew --disposable --autoclose=2 --width=0.9 --height=0.9 lazygit<CR>')
vim.keymap.set('n', '<leader>fg', ':LazyGit<CR>')
vim.keymap.set('n', '<leader>ft', ':FloatermNew --disposable --autoclose=2 taskwarrior-tui<CR>')
vim.keymap.set('n', '<leader>ff', ':FloatermToggle<CR>')
vim.keymap.set('t', '<leader>ff', '<C-\\><C-n>:FloatermToggle<CR>')
vim.keymap.set('t', '<leader>fg', '<C-\\><C-n>:FloatermToggle<CR>')
vim.keymap.set('t', '<leader>fj', '<C-\\><C-n>')
vim.keymap.set('t', '<leader>fH', '<C-\\><C-n>:FloatermPrev<CR>')
vim.keymap.set('t', '<leader>fL', '<C-\\><C-n>:FloatermNext<CR>')
vim.keymap.set({ 'v', 'n' }, '<leader>f>', ':FloatermSend<CR>')

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-?>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')
  -- Create a command `:Format` local to the LSP buffer
  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   vim.lsp.buf.format()
  -- end, { desc = 'Format current buffer with LSP' })
end

-- TEST:
vim.keymap.set('t', '<leader>fL', '<C-\\><C-n>:FloatermNext<CR>')
vim.keymap.set('n', '<leader>tn', ':TestNearest<CR>')
vim.keymap.set('n', '<leader>tN', ':TestNearest -strategy=floaterm<CR>')
vim.keymap.set('n', '<leader>tm', ':TestNearest -strategy=shtuff<CR>')
vim.keymap.set('n', '<leader>td', ':TestNearest -strategy=vimspectorpy -vv<CR>')
vim.keymap.set('n', '<leader>tf', ':TestFile<CR>')
vim.keymap.set('n', '<leader>tF', ':TestFile -strategy=shtuff<CR>')
vim.keymap.set('n', '<leader>ts', ':TestSuite<CR>')
vim.keymap.set('n', '<leader>tS', ':TestSuite -strategy=shtuff<CR>')
vim.keymap.set('n', '<leader>tl', ':TestLast -strategy=floaterm<CR>')
vim.keymap.set('n', '<leader>tL', ':TestLast -strategy=quickfix<CR>')
vim.keymap.set('n', '<leader>tg', ':TestVisit<CR>')
vim.keymap.set('n', '<leader>tt', ':TestLast<CR>')
vim.keymap.set('n', '<leader>tT', ':TestLast -strategy=shtuff -vv<CR>')

-- LSP:
vim.keymap.set('n', '<leader>cf', ':Format<CR>')
--vim.keymap.set({ 'n', 'v' }, 'cf', vim.lsp.buf.format)


-- NVIMTREE:
--vim.keymap.set('n', '<leader>nn', '<cmd>NvimTreeToggle<cr>')
--vim.keymap.set('n', '<leader>ne', '<cmd>NvimTreeFocus<cr>')
--vim.keymap.set('n', '<leader>nf', '<cmd>NvimTreeFindFile<cr>')
--vim.keymap.set('n', '<leader>nr', '<cmd>NvimTreeRefresh<cr>')
vim.keymap.set('n', '<leader>nn', '<cmd>Oil .<cr>')
vim.keymap.set('n', '<leader>ne', '<cmd>Oil .<cr>')
vim.keymap.set('n', '<leader>nf', '<cmd>Oil<cr>')

-- Obsidian:
local group = vim.api.nvim_create_augroup("ObsidianMapping", { clear = true })
vim.api.nvim_create_autocmd("BufEnter", { callback = function(arg)
  local bufnr = arg['buf']
  vim.keymap.set('n', '<CR>', ':ObsidianFollowLink<CR>', { buffer = bufnr, desc = "Follow links in obsidian" })
  vim.keymap.set('n', '<leader>tt', ':MarkdownPreviewToggle<CR>', { buffer = bufnr, desc = "Toggles the perview of the markdown" })
  vim.keymap.set('n', '<leader>x', require('obsidian').util.toggle_checkbox, { buffer = bufnr, desc = "Toggle check-boxes" })
  -- I should get used to <leader>wp instead
  -- vim.keymap.set('n', '<C-p>', ':ObsidianQuickSwitch<CR>', { buffer = bufnr, desc = "Finds a file  in the docs" })
end, group = group, pattern = "*.md" })
--autocmd FileType vimwiki nnoremap <CR> :ObsidianFollowLink<CR>
vim.keymap.set('n', '<leader>ww', ':ObsidianToday<cr>')
vim.keymap.set('n', '<leader>wh', ':ObsidianYesterday<cr>')
vim.keymap.set('n', '<leader>sW', ':ObsidianQuickSwitch<cr>', { desc = '[S]earch [W]iki' })
vim.keymap.set('n', '<leader>w/', ':ObsidianSearch<cr>', { desc = '[S]earch [W]iki' })
vim.keymap.set('n', '<leader>wp', ':ObsidianQuickSwitch<cr>', { desc = '[W]iki switch' })
--vim.keymap.set('n', '<leader>sW', function ()
--  --require('telescope.builtin').find_files({ search_dirs = { '~/code/braindump/work/' } } )
--end, { desc = '[S]earch [S]scripts' })

-- local hop = require('hop')
-- local directions = require('hop.hint').HintDirection
--vim.keymap.set('', 'f', function()
--  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
--end, { remap = true })
--vim.keymap.set('', 'F', function()
--  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
--end, { remap = true })
--vim.keymap.set('', 't', function()
--  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
--end, { remap = true })
--vim.keymap.set('', 'T', function()
--  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
--end, { remap = true })

vim.keymap.set('', '<leader>h', ':HopChar2<CR>')
vim.keymap.set('', 's', ':HopChar2<CR>')


-- Silly things
vim.keymap.set('n', '<leader>wt', ':TransparentToggle<cr>')


local mappings = {}
mappings.on_attach = on_attach
return mappings
