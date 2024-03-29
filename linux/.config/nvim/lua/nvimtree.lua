require'nvim-tree'.setup {
  -- We can disable netrw but it's useful to open links with gx
  -- disable_netrw       = true,
  -- hijack_netrw        = true,
  disable_netrw       = false,
  hijack_netrw        = true,

  tab = {
    sync = {
      open = true
    }
  },
  -- open_on_setup       = false,
  -- ignore_ft_on_setup  = {},
  -- auto_close          = false,
  -- open_on_tab         = false,
  hijack_cursor       = false,
  update_cwd          = false,
  hijack_directories  = {
    enable = true,
    auto_open = true,
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    }
  },
  update_focused_file = {
    enable      = false,
    update_cwd  = false,
    ignore_list = {}
  },
  system_open = {
    cmd  = nil,
    args = {}
  },
  filters = {
    dotfiles = false,
    custom = {}
  },
  view = {
    width = 30,
    -- hide_root_folder = false,
    side = 'left',
  },
  actions = {
    open_file = {
      resize_window = false
    }
  }
}
