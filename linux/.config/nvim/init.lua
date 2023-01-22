-- Install packer
require("settings")
require("plugins")
-- [[ Setting options ]]
-- See `:help vim.o`

-- Do not map keys for easymotion
vim.g.EasyMotion_do_mapping = 0

require("mappings")

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

require("pluginconf")
require("telescopeconf")
require("nvimlspconfig")
require("formattingconf")
--require("nvimcmp")
require("nvimtree")
