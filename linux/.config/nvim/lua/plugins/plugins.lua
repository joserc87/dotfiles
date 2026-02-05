return {
  { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  },
  { -- I don't really use fidget, but it's giving me a warning and I have to force the legacy tag
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require("fidget").setup {
	-- options
      }
    end,
  },
  { -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      -- Useful completion sources:
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/vim-vsnip',
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip'
    },
  },
  {
    'github/copilot.vim'
  },
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    build = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  },
  { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  },
  -- MOTION:
  --use 'easymotion/vim-easymotion'
  {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  },
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
  'voldikss/vim-floaterm',
  {
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  'metakirby5/codi.vim',
  'kshenoy/vim-signature',
  'itchyny/vim-cursorword',
  -- 'nvim-lua/popup.nvim',
  'nvim-lua/plenary.nvim',
  -- Window maximizer
  'szw/vim-maximizer',

  -- Git related plugins
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'shumphrey/fugitive-gitlab.vim',
  'junegunn/gv.vim',
  'lewis6991/gitsigns.nvim',
  'sindrets/diffview.nvim',

  -- FILE_NAVIGATION:
  'kyazdani42/nvim-tree.lua',
  'tpope/vim-projectionist',
  { 'stevearc/oil.nvim', config = function() require('oil').setup() end },
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
  'nvim-lualine/lualine.nvim', -- Fancier statusline
  'lukas-reineke/indent-blankline.nvim', -- Add indentation guides even on blank lines
  'numToStr/Comment.nvim', -- "gc" to comment visual regions/lines
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
    -- ft = "markdown" -- If you decide to lazy-load anyway

    -- dependencies = {
    --     "nvim-treesitter/nvim-treesitter",
    --     "nvim-tree/nvim-web-devicons"
    -- }
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
  {
    'glacambre/firenvim',
    build = function() vim.fn['firenvim#install'](0) end
  },
  -- ICONS:
  'ryanoasis/vim-devicons',
  'kyazdani42/nvim-web-devicons',

  -- Fuzzy Finder (files, lsp, etc)
  {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      dependencies = {
          'nvim-lua/plenary.nvim',
          'nvim-telescope/telescope-live-grep-args.nvim'
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
  'janko/vim-test',
  'tpope/vim-dispatch',
  {
    "andythigpen/nvim-coverage",
    dependencies = "nvim-lua/plenary.nvim",
    -- Optional: needed for PHP when using the cobertura parser
    rocks = { 'lua-xmlreader' },
    config = function()
      require("coverage").setup()
    end,
  },

  -- DEBUG:
  'puremourning/vimspector',
}
