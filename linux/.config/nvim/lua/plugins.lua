
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- I don't really use fidget, but it's giving me a warning and I have to force the legacy tag
    'j-hui/fidget.nvim',
    tag = 'legacy',
    config = function()
      require("fidget").setup {
	-- options
      }
    end,
  }

  use { -- Autocompletion
    'hrsh7th/nvim-cmp',
    requires = {
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
  }

  use {
    'github/copilot.vim'
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- MOTION:
  --use 'easymotion/vim-easymotion'
  use {
    'phaazon/hop.nvim',
    branch = 'v2', -- optional but strongly recommended
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
    end
  }
  use 'christoomey/vim-tmux-navigator'
  -- Not migrated yet
  -- use ({
  --   'aserowy/tmux.nvim',
  --   config = function() return require("tmux").setup() end
  -- })
  use 'benmills/vimux'

  -- EDIT:
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-surround'
  use 'tpope/vim-commentary'
  use 'tpope/vim-repeat'
  use 'godlygeek/tabular'
  -- new objects
  use 'kana/vim-textobj-user'
  use 'kana/vim-textobj-entire'
  use 'michaeljsmith/vim-indent-object'
  use 'lucapette/vim-textobj-underscore'
  use 'wellle/targets.vim'
  use 'idbrii/textobj-word-column.vim'
  -- Automatically add some closing quotes
  -- Plug 'Raimondi/delimitMate'

  -- UI:
  use 'voldikss/vim-floaterm'
  use({
    "kdheepak/lazygit.nvim",
    -- optional for floating window border decoration
    requires = {
      "nvim-lua/plenary.nvim",
    },
  })
  use 'metakirby5/codi.vim'
  use 'kshenoy/vim-signature'
  use 'itchyny/vim-cursorword'
  -- use 'nvim-lua/popup.nvim'
  use 'nvim-lua/plenary.nvim'
  -- Window maximizer
  use 'szw/vim-maximizer'

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'shumphrey/fugitive-gitlab.vim'
  use 'junegunn/gv.vim'
  use 'lewis6991/gitsigns.nvim'

  -- FILE_NAVIGATION:
  use 'kyazdani42/nvim-tree.lua'
  use 'tpope/vim-projectionist'
  use { 'stevearc/oil.nvim', config = function() require('oil').setup() end }
  use { 'rmagatti/gx-extended.nvim', config = function() require('gx-extended').setup {} end }

  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use 'xiyaowong/transparent.nvim' -- Transparent background
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- PYTHON:
  --- use '5long/pytest-vim-compiler'
  --- use 'mattboehm/vim-unstack'
  --- use 'sagi-z/vimspectorpy', { 'do': { -> vimspectorpy#update() } }

  -- WIKI:
  -- Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
  -- Plug 'tools-life/taskwiki'
  use 'itchyny/calendar.vim'
  -- Disabled because it messes with gx :(
  -- use 'preservim/vim-markdown'
  use 'epwalsh/obsidian.nvim'
  use({
      "iamcco/markdown-preview.nvim",
      run = function() vim.fn["mkdp#util#install"]() end,
  })
  -- markview is a bit too much, unless in readonly mode
  -- use ({
  --   "OXY2DEV/markview.nvim",
  --   -- ft = "markdown" -- If you decide to lazy-load anyway

  --   -- dependencies = {
  --   --     "nvim-treesitter/nvim-treesitter",
  --   --     "nvim-tree/nvim-web-devicons"
  --   -- }
  -- })

  -- Disabled because the MF takes 2GB of disk just for this plugin (.so libs)
  -- use { 'mistricky/codesnap.nvim', run = "make" }
  -- Focus mode:
  use({
	"Pocco81/true-zen.nvim",
	config = function()
		 require("true-zen").setup {
			-- your config goes here
			-- or just leave it empty :)
		 }
	end,
  })

  -- INTEGRATIONS:
  use 'tpope/vim-dotenv'
  use {
    'glacambre/firenvim',
    run = function() vim.fn['firenvim#install'](0) end
  }

  -- ICONS:
  use 'ryanoasis/vim-devicons'
  use 'kyazdani42/nvim-web-devicons'

  -- Fuzzy Finder (files, lsp, etc)
  -- use { 'junegunn/fzf', run = fzf#install() }
  -- use 'junegunn/fzf.vim'
  use {
      'nvim-telescope/telescope.nvim',
      branch = '0.1.x',
      requires = {
          'nvim-lua/plenary.nvim',
          'nvim-telescope/telescope-live-grep-args.nvim'
      },
      config = function ()
          require("telescope").load_extension("live_grep_args")
      end
  }


  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

  use 'xiyaowong/telescope-emoji.nvim'

  -- FORMAT:
  use 'mhartington/formatter.nvim'

  -- TESTS:
  use 'janko/vim-test'
  use 'tpope/vim-dispatch'
  use({
    "andythigpen/nvim-coverage",
    requires = "nvim-lua/plenary.nvim",
    -- Optional: needed for PHP when using the cobertura parser
    rocks = { 'lua-xmlreader' },
    config = function()
      require("coverage").setup()
    end,
  })

  -- DEBUG:
  use 'puremourning/vimspector'

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})
