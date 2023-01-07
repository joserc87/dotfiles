-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- 4 spaces instead of a tab
vim.g.tabstop = 4
vim.g.shiftwidth = 4
vim.g.expandtab = true

-- Reload files automatically
vim.g.autoread = true

-- Don't write backup files
vim.g.backup = false
vim.g.writebackup = false
vim.g.swapfile = false

-- Open new split panes to right and bottom, which feels more natural than
-- Vim's default
vim.g.splitbelow = true
vim.g.splitright = true

-- Shows number + relative. Otherwise, set rnu
vim.g.number = true
vim.g.relativenumber = true

-- Enable per-project .vimrc
-- vim.g.exrc = true
--

vim.g.localvimrc_sandbox = 0
vim.g.localvimrc_persistent = 1
-- Because we enable external .vimrc's, we prevent :autocmd, shell and write
-- commands being run inside project-specific .vimrc unless they are owned by
vim.g.secure = true

vim.g.python_host_prog = '~/.pyenv/versions/neovim2/bin/python'
vim.g.python3_host_prog = '~/.pyenv/versions/neovim3/bin/python'
vim.env.EDITOR = 'floaterm'
-- Open Jira as markdown. To be tested...
-- au BufEnter jira.ravenpack.com_*.txt set filetype=markdown
vim.api.nvim_create_autocmd("BufEnter", { callback = function(arg)
    vim.b.filetype = 'markdown'
end, pattern = 'jira.ravenpack.com_*.txt'})

-- GBrowse doesn't work if netrw is disabled, so we define our own command
vim.cmd(
  [[
  function! Browse(pathOrUrl)
    " This doesn't work with /usr/bin/vim on macOS (doesn't identify as macOS).
    if has('mac')| let openCmd = 'open'| else| let openCmd = 'xdg-open'| endif
      silent execute "! " . openCmd . " " . shellescape(a:pathOrUrl, 1)| " Escape Path or URL and pass as arg to open command.
      echo openCmd . " " shellescape(a:pathOrUrl, 1)| " Echo what we ran so it's visible.
  endfunction
  command! -nargs=1 Browse call Browse(<q-args>)|     " :Browse runs :call Browse() (defined above).
  ]]
)

-- Set highlight on search
vim.o.hlsearch = false

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
