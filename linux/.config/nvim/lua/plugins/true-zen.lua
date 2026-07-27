-- Saved by our minimalist open_pre/close_pos callbacks below, see the comment there.
local saved_minimalist_opts = nil

return {
  {
    'Pocco81/true-zen.nvim',
    dependencies = { 'folke/twilight.nvim' },
    cmd = { 'TZAtaraxis', 'TZMinimalist', 'TZFocus', 'TZNarrow' },
    keys = {
      { '<leader>za', ':TZAtaraxis<CR>', desc = 'True-Zen: Ataraxis' },
      { '<leader>zm', ':TZMinimalist<CR>', desc = 'True-Zen: Minimalist' },
      { '<leader>zf', ':TZFocus<CR>', desc = 'True-Zen: Focus' },
      { '<leader>zn', ':TZNarrow<CR>', desc = 'True-Zen: Narrow' },
      { '<leader>zn', ':<C-u>TZNarrow<CR>', mode = 'v', desc = 'True-Zen: Narrow selection' },
    },
    config = function()
      require('true-zen').setup {
        modes = {
          ataraxis = {
            shade = 'dark',
            backdrop = 0.15,
            minimum_writing_area = {
              width = 70,
              height = 44,
            },
            quit_untoggles = true,
            padding = {
              left = 52,
              right = 52,
              top = 0,
              bottom = 0,
            },
          },
          minimalist = {
            ignored_buf_types = { 'nofile' },
            callbacks = {
              open_pre = function()
                saved_minimalist_opts = {
                  cmdheight = vim.o.cmdheight,
                  laststatus = vim.o.laststatus,
                  showtabline = vim.o.showtabline,
                  numberwidth = vim.o.numberwidth,
                }
                vim.o.cmdheight = 0
                vim.o.laststatus = 0
                vim.o.showtabline = 0
                vim.o.numberwidth = 1
              end,
              close_pos = function()
                if saved_minimalist_opts then
                  vim.o.cmdheight = saved_minimalist_opts.cmdheight
                  vim.o.laststatus = saved_minimalist_opts.laststatus
                  vim.o.showtabline = saved_minimalist_opts.showtabline
                  vim.o.numberwidth = saved_minimalist_opts.numberwidth
                  saved_minimalist_opts = nil
                end
              end,
            },
          },
          narrow = {
              --- change the style of the fold lines. Set it to:
              --- `informative`: to get nice pre-baked folds
              --- `invisible`: hide them
              --- function() end: pass a custom func with your fold lines. See :h foldtext
              folds_style = "invisible",
              run_ataraxis = true, -- display narrowed text in a Ataraxis session
              callbacks = {
                -- narrow.lua's M.off() clears its own `b.tz_narrowed_buffer` flag *before*
                -- calling ataraxis.off() (which tears down the padding windows and re-enters
                -- this buffer, retriggering our treesitter FileType autocmd). By the time that
                -- autocmd runs, true-zen's own flag is already gone, so it re-forces
                -- foldmethod=expr and narrow.lua's own "must be manual" check then fails. Set our
                -- own flag here instead, since these callbacks fire before that flag is cleared.
                open_pre = nil,
                open_pos = nil,
                close_pre = function()
                  vim.g.tz_narrow_closing = true
                end,
                close_pos = function()
                  vim.g.tz_narrow_closing = false
                end,
              },
          },
        },
        integrations = {
          lualine = true,
          -- twilight = true,
        },
      }

      -- true-zen's save/restore code mangles any Number-type option into a boolean
      -- (https://github.com/Pocco81/true-zen.nvim/pull/143), so restoring cmdheight/laststatus/
      -- showtabline/numberwidth crashes with "expected number, got boolean". setup() merges
      -- rather than replaces, so passing these as `options = {}` above still leaves the
      -- defaults in place; delete them from the live config instead, and manage the 4 of them
      -- ourselves via the callbacks below.
      local minimalist_opts = require('true-zen.config').options.modes.minimalist.options
      minimalist_opts.cmdheight = nil
      minimalist_opts.laststatus = nil
      minimalist_opts.showtabline = nil
      minimalist_opts.numberwidth = nil
    end,
  },
}
