return {
  {
    'tpope/vim-fugitive',
    config = function()
      local g = vim.g
      local bo = vim.bo
      
      vim.api.nvim_create_autocmd("BufReadPost", {
        callback = function()
          bo.bufhidden = 'delete'
        end,
        pattern = 'fugitive://*'
      })
      
      g.fugitive_gitlab_domains = { 'https://gitlab.ravenpack.com' }
    end,
  },
  'tpope/vim-rhubarb',
  'shumphrey/fugitive-gitlab.vim',
  'junegunn/gv.vim',
  'sindrets/diffview.nvim',
}
