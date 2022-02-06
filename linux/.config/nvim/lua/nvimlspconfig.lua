require'lspconfig'.pyright.setup{}

vim.diagnostic.config({
  -- To disable:
  -- virtual_text = false,
  virtual_text = {
    source = "if_many",  -- Or "if_many"
    prefix = '❓',
  },
  float = {
    source = "always",  -- Or "if_many"
  },
})
