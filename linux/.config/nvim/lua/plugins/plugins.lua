return {
  -- MOTION:
  --use 'easymotion/vim-easymotion'
  'christoomey/vim-tmux-navigator',
  -- Not migrated yet
  -- {
  --   'aserowy/tmux.nvim',
  --   config = function() return require("tmux").setup() end
  -- },
  'benmills/vimux',

  -- EDIT:
  'tpope/vim-unimpaired',
  'tpope/vim-surround',
  'tpope/vim-commentary',
  'tpope/vim-repeat',
  'godlygeek/tabular',
  -- new objects
  'kana/vim-textobj-user',
  {
    'kana/vim-textobj-entire',
    dependencies = { 'kana/vim-textobj-user' },
  },
  'michaeljsmith/vim-indent-object',
  {
    'lucapette/vim-textobj-underscore',
    dependencies = { 'kana/vim-textobj-user' },
  },
  'wellle/targets.vim',
  {
    'idbrii/textobj-word-column.vim',
    dependencies = { 'kana/vim-textobj-user' },
  },
  -- Automatically add some closing quotes
  -- 'Raimondi/delimitMate',

  -- UI:
  'metakirby5/codi.vim',
  'kshenoy/vim-signature',
  'itchyny/vim-cursorword',
  -- 'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',
  -- Window maximizer
  'szw/vim-maximizer',

  -- Git related plugins

  -- FILE_NAVIGATION:
  'kyazdani42/nvim-tree.lua',
  'tpope/vim-projectionist',
  { 'rmagatti/gx-extended.nvim', config = function() require('gx-extended').setup {} end },
  {
    "navarasu/onedark.nvim",
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      require('onedark').setup {
	style = 'darker'
      }
      require('onedark').load()
    end
  },
  'xiyaowong/transparent.nvim', -- Transparent background
  'tpope/vim-sleuth', -- Detect tabstop and shiftwidth automatically

  -- PYTHON:
  --- '5long/pytest-vim-compiler',
  --- 'mattboehm/vim-unstack',
  --- 'sagi-z/vimspectorpy', { 'do': { -> vimspectorpy#update() } }

  -- WIKI:
  -- Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
  -- 'tools-life/taskwiki',
  'itchyny/calendar.vim',
  -- Disabled because it messes with gx :(
  -- 'preservim/vim-markdown',
  'epwalsh/obsidian.nvim',
  {
      "iamcco/markdown-preview.nvim",
      build = function() vim.fn["mkdp#util#install"]() end,
  },
  -- markview is a bit too much, unless in readonly mode
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    -- ft = "markdown" -- If you decide to lazy-load anyway

    -- dependencies = {
    --     "nvim-treesitter/nvim-treesitter",
    --     "nvim-tree/nvim-web-devicons"
    -- }
    config = function()
      require("markview").setup({
        preview = { enable = false }
      })
    end,
  },

  -- Disabled because the MF takes 2GB of disk just for this plugin (.so libs)
  -- { 'mistricky/codesnap.nvim', build = "make" }
  -- Focus mode:
  {
	"Pocco81/true-zen.nvim",
	config = function()
		 require("true-zen").setup {
			-- your config goes here
			-- or just leave it empty :)
		 }
	end,
  },

  -- INTEGRATIONS:
  'tpope/vim-dotenv',
  -- ICONS:
  'ryanoasis/vim-devicons',
  'kyazdani42/nvim-web-devicons',

  -- Fuzzy Finder (files, lsp, etc)
  {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
          'nvim-lua/plenary.nvim',
          'nvim-telescope/telescope-live-grep-args.nvim',
          'nvim-treesitter/nvim-treesitter'
      },
      config = function ()
          require("telescope").load_extension("live_grep_args")
      end
  },


  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make'
  },
  'xiyaowong/telescope-emoji.nvim',
  -- FORMAT:
  'mhartington/formatter.nvim',

  -- TESTS:

  -- DEBUG:
  'puremourning/vimspector',
}
