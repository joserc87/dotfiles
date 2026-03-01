return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    priority = 100,
    build = ':TSUpdate',
    config = function()
      -- Parsers will be installed via the build command ':TSUpdate'
      -- You can manually install more with :TSInstall <language>
      
      -- Provide a fallback for ft_to_lang if it's missing (for Telescope compatibility)
      local ts_ok, _ = pcall(require, 'nvim-treesitter')
      if ts_ok then
        local parsers = require('nvim-treesitter.parsers')
        if parsers and not parsers.ft_to_lang then
          parsers.ft_to_lang = function(ft)
            -- Simple fallback mapping
            local ft_to_parser = {
              cpp = 'cpp',
              python = 'python',
              rust = 'rust',
              lua = 'lua',
              javascript = 'javascript',
              typescript = 'typescript',
              go = 'go',
              c = 'c',
              yaml = 'yaml',
              json = 'json',
              markdown = 'markdown',
              html = 'html',
              css = 'css',
              bash = 'bash',
              sh = 'bash',
              vim = 'vim',
            }
            return ft_to_parser[ft] or ft
          end
        end
      end

      -- Enable treesitter highlighting for all filetypes
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- Enable treesitter-based folding
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
          vim.wo[0][0].foldmethod = 'expr'
        end,
      })

      -- Enable treesitter-based indentation (experimental)
      vim.api.nvim_create_autocmd('FileType', {
        pattern = '*',
        callback = function()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      -- Hack to make treesitter folding work after opening file with telescope
      vim.api.nvim_create_autocmd({ "BufEnter" }, {
        pattern = { "*" },
        command = "normal zR",
      })

      -- Incremental selection keymaps
      vim.keymap.set('n', '<c-space>', function()
        vim.cmd('normal! v')
        require('nvim-treesitter.incremental_selection').init_selection()
      end, { desc = 'Init treesitter selection' })
      vim.keymap.set('v', '<c-space>', function()
        require('nvim-treesitter.incremental_selection').node_incremental()
      end, { desc = 'Increment treesitter selection' })
      vim.keymap.set('v', '<c-s>', function()
        require('nvim-treesitter.incremental_selection').scope_incremental()
      end, { desc = 'Increment treesitter scope' })
      vim.keymap.set('v', '<c-backspace>', function()
        require('nvim-treesitter.incremental_selection').node_decremental()
      end, { desc = 'Decrement treesitter selection' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    branch = 'main',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      -- Setup textobjects
      require("nvim-treesitter-textobjects").setup({
        select = {
          lookahead = true,
          include_surrounding_whitespace = false,
        },
        move = {
          set_jumps = true,
        },
      })

      -- Text object selection keymaps
      local select = require("nvim-treesitter-textobjects.select")
      vim.keymap.set({ "x", "o" }, "aa", function()
        select.select_textobject("@parameter.outer", "textobjects")
      end, { desc = "Select outer parameter" })
      vim.keymap.set({ "x", "o" }, "ia", function()
        select.select_textobject("@parameter.inner", "textobjects")
      end, { desc = "Select inner parameter" })
      vim.keymap.set({ "x", "o" }, "af", function()
        select.select_textobject("@function.outer", "textobjects")
      end, { desc = "Select outer function" })
      vim.keymap.set({ "x", "o" }, "if", function()
        select.select_textobject("@function.inner", "textobjects")
      end, { desc = "Select inner function" })
      vim.keymap.set({ "x", "o" }, "ac", function()
        select.select_textobject("@class.outer", "textobjects")
      end, { desc = "Select outer class" })
      vim.keymap.set({ "x", "o" }, "ic", function()
        select.select_textobject("@class.inner", "textobjects")
      end, { desc = "Select inner class" })

      -- Text object move keymaps
      local move = require("nvim-treesitter-textobjects.move")
      vim.keymap.set({ "n", "x", "o" }, "]m", function()
        move.goto_next_start("@function.outer", "textobjects")
      end, { desc = "Next function start" })
      vim.keymap.set({ "n", "x", "o" }, "]]", function()
        move.goto_next_start("@class.outer", "textobjects")
      end, { desc = "Next class start" })
      vim.keymap.set({ "n", "x", "o" }, "]M", function()
        move.goto_next_end("@function.outer", "textobjects")
      end, { desc = "Next function end" })
      vim.keymap.set({ "n", "x", "o" }, "][", function()
        move.goto_next_end("@class.outer", "textobjects")
      end, { desc = "Next class end" })
      vim.keymap.set({ "n", "x", "o" }, "[m", function()
        move.goto_previous_start("@function.outer", "textobjects")
      end, { desc = "Previous function start" })
      vim.keymap.set({ "n", "x", "o" }, "[[", function()
        move.goto_previous_start("@class.outer", "textobjects")
      end, { desc = "Previous class start" })
      vim.keymap.set({ "n", "x", "o" }, "[M", function()
        move.goto_previous_end("@function.outer", "textobjects")
      end, { desc = "Previous function end" })
      vim.keymap.set({ "n", "x", "o" }, "[]", function()
        move.goto_previous_end("@class.outer", "textobjects")
      end, { desc = "Previous class end" })

      -- Text object swap keymaps
      local swap = require("nvim-treesitter-textobjects.swap")
      vim.keymap.set("n", "<leader>a", function()
        swap.swap_next("@parameter.inner")
      end, { desc = "Swap with next parameter" })
      vim.keymap.set("n", "<leader>A", function()
        swap.swap_previous("@parameter.inner")
      end, { desc = "Swap with previous parameter" })
    end,
  },
}
