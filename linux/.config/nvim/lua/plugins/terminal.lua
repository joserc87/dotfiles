return {
  {
    'voldikss/vim-floaterm',
    config = function()
      local g = vim.g
      
      g.floaterm_gitcommit = 'floaterm'
      g.floaterm_autoinsert = 1
      g.floaterm_width = 0.8
      g.floaterm_height = 0.8
      g.floaterm_wintitle = 0
      g.floaterm_autoclose = 1
      g.floaterm_opener = 'edit'
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      function EditLineFromLazygit(file_path, line)
        local path = vim.fn.expand("%:p")
        if path == file_path then
          vim.cmd(tostring(line))
        else
          vim.cmd("e " .. file_path)
          vim.cmd(tostring(line))
        end
      end

      function EditFromLazygit(file_path)
        local path = vim.fn.expand("%:p")
        if path ~= file_path then
          vim.cmd("e " .. file_path)
        end
      end
    end,
  },
}
