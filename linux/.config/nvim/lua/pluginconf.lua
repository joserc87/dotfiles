-- Obsidian
require("obsidian").setup({
  dir = "~/code/braindump/work",
  daily_notes = {
      folder = "diary"
  },
  completion = {
    nvim_cmp = false, -- if using nvim-cmp, otherwise set to false
  }
})
vim.keymap.set(
  "n",
  "gf",
  function()
    if require('obsidian').util.cursor_on_markdown_link() then
      return "<cmd>ObsidianFollowLink<CR>"
    else
      return "gf"
    end
  end,
  { noremap = false, expr = true}
)

-- Autosession
require('auto-session').setup({
  log_level = 'info',
  auto_session_enable_last_session = false,
  -- auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
  auto_session_enabled = false,
  auto_session_allowed_dirs = {"/home/jcano/git/entitytool/", "/home/jcano/git/pysync/"}
})

-- Lualine
require('lualine').setup {
  options = {
    theme = 'onedark'
    -- ... your lualine config
  }
}

-- LSP Saga
require('lspsaga').init_lsp_saga {

  error_sign = '⛔',
  warn_sign = '⚠️',
  hint_sign = '💡',
  infor_sign = '💡',
  diagnostic_header_icon = '   ',
  code_action_icon = ' ',
}
require'hop'.setup()
