-- Put in ~/.vim/lua/formatting.lua
-- Formatters
-- Formatting can be run via :Format
local formatter = require('formatter')

-- local eslint_fmt = {
--   function()
--     return {
--       exe = "./node_modules/.bin/eslint",
--       args = {"--fix", "--stdin-filename", vim.api.nvim_buf_get_name(0)},
--       stdin = false,
--     }
--   end
-- }
--
formatter.setup {
  logging = true,
  filetype = {
    lua = { require("formatter.filetypes.lua").stylua },
    typescript = eslint_fmt,
    typescriptreact = eslint_fmt,
    python = {
      function ()
        return {
          exe = 'black',
          args = {"-"},
          stdin = true,
        }
      end,
      function ()
        return {
          exe = 'isort',
          args = {"--profile", "black", "-"},
          stdin = true,
        }
      end
    },
    go = { require("formatter.filetypes.go").gofmt },
    -- Use the special "*" filetype for defining formatter configurations on
    -- any filetype
    ["*"] = {
      -- "formatter.filetypes.any" defines default configurations for any
      -- filetype
      require("formatter.filetypes.any").remove_trailing_whitespace
    },
  }
}
