return {
  {
    'janko/vim-test',
    dependencies = {
      'tpope/vim-dispatch',
    },
    config = function()
      local g = vim.g
      
      g["test#python#runner"] = 'pytest'
      g["test#python#options"] = {
        suite='-vv -m "not slow and not skip and not knownfail and not require_cache"',
        nearest='-vv',
        file='-vv',
      }
      g["test#strategy"] = "dispatch"
      g["g:test#preserve_screen"] = 1
      
      g.dispatch_compilers = {
        ['./vendor/bin/'] = 'pytest',
        pyunit = 'pytest',
        python = 'pytest%',
      }
      g.shtuff_receiver = vim.fn.getcwd()
      g["g:vimspectorpy#launcher"] = "tmux"
    end,
  },
  'tpope/vim-dispatch',
  {
    "andythigpen/nvim-coverage",
    dependencies = "nvim-lua/plenary.nvim",
    rocks = { 'lua-xmlreader' },
    config = function()
      require("coverage").setup({
        commands = true,
        highlights = {
          covered = { fg = "#C3E88D" },
          uncovered = { fg = "#F07178" },
        },
        signs = {
          covered = { hl = "CoverageCovered", text = "▎" },
          uncovered = { hl = "CoverageUncovered", text = "▎" },
        },
        summary = {
          min_coverage = 80.0,
        },
        lang = {},
      })
    end,
  },
}
