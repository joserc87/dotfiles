local opts = {
  log_level = 'info',
  auto_session_enable_last_session = false,
  -- auto_session_root_dir = vim.fn.stdpath('data').."/sessions/",
  auto_session_enabled = false,
  auto_session_allowed_dirs = {"/home/jcano/git/entitytool/", "/home/jcano/git/pysync/"}
}

require('auto-session').setup(opts)
print('This works')
