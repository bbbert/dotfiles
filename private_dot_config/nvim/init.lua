-- bbbert's nvim/init.lua
-- ----------------------

-- Plugins (vim-plug) {{{1
-- ------------------

-- Automatic vim-plug and plugin installation on first load
vim.cmd [[
  let plugpath = stdpath('data') . '/site/autoload/plug.vim'
  if empty(glob(plugpath))
    silent execute '!curl -fLo ' . plugpath . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
]]

local Plug = vim.fn['plug#']
vim.call('plug#begin', vim.fn.stdpath('data') .. '/plugged')

-- Workspace features {{{2
-- ------------------

-- vim-startify
Plug 'mhinz/vim-startify'

-- Icons
Plug 'ryanoasis/vim-devicons'
Plug 'kyazdani42/nvim-web-devicons'

-- Themes for Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

-- Sync tmux config with airline config
Plug 'edkolev/tmuxline.vim'

-- Gitsigns
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim' -- needs nvim-lua/plenary.nvim

-- NERDTree
Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'

-- Bufkill
Plug 'qpkorr/vim-bufkill'

-- Gundo
Plug 'sjl/gundo.vim'

-- Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

-- Seamless split navigation with tmux
Plug 'christoomey/vim-tmux-navigator'

-- Zoom into a split
Plug 'dhruvasagar/vim-zoom'

-- Instant collaboration
Plug 'jbyuki/instant.nvim'

-- }}}

-- LSP {{{2
-- ---

-- LSP configs
Plug 'neovim/nvim-lspconfig'

-- Special LSP config for neovim Lua development
Plug 'folke/lua-dev.nvim'

-- Icons for LSP completion
Plug 'onsails/lspkind-nvim'

-- Diagnostics
Plug 'folke/trouble.nvim'

-- FZF integration
Plug 'gfanto/fzf-lsp.nvim'

-- Lightbulb beside code actions
Plug 'kosayoda/nvim-lightbulb'

-- Treesitter
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

-- }}}

-- Code tools {{{2
-- ----------

-- Completion
Plug 'hrsh7th/nvim-compe'

-- Snippets
Plug 'hrsh7th/vim-vsnip'

-- Symbol outline
Plug 'liuchengxu/vista.vim'

-- Documentation generator
Plug('kkoomen/vim-doge', { ['do'] = ':call doge#install()' })

-- }}}

-- Colorschemes {{{2
-- ------------

-- A whole set of colorschemes
Plug 'rafi/awesome-vim-colorschemes'

-- Solarized colorscheme
Plug 'icymind/NeoSolarized'

-- One (Atom) colorscheme for vim
Plug 'rakr/vim-one'

-- }}}

-- Text editing {{{2
-- ------------

-- tpope's text utilities
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

-- tpope's commentary
Plug 'tpope/vim-commentary'

-- Subversive, works well with abolish
Plug 'svermeulen/vim-subversive'

-- Custom textobjs
Plug 'kana/vim-textobj-user'

Plug 'Julian/vim-textobj-brace'          -- aj/ij for braces
Plug 'beloglazov/vim-textobj-quotes'     -- aq/iq for quotes
Plug 'kana/vim-textobj-datetime'         -- ada/ida for dates
Plug 'kana/vim-textobj-indent'           -- ai/ii, aI/iI for block of lines of similar indentation
Plug 'kana/vim-textobj-line'             -- al/il for current line
Plug 'kana/vim-textobj-entire'           -- ae/ie for entire file
Plug 'whatyouhide/vim-textobj-xmlattr'   -- ax/ix for xml/html attributes

Plug 'nvim-treesitter/nvim-treesitter-textobjects'
Plug 'RRethy/nvim-treesitter-textsubjects'

-- Tabular
Plug 'godlygeek/tabular'

-- Vim table mode
Plug 'dhruvasagar/vim-table-mode'

-- Highlight yanks
Plug 'machakann/vim-highlightedyank'

-- Increment numbers
Plug 'triglav/vim-visual-increment'

-- Vim search pulse
Plug 'inside/vim-search-pulse'

-- Lightspeed movements (replaces sSfFtT movements in normal and visual mode)
Plug 'ggandor/lightspeed.nvim'

-- }}}

-- Languages {{{2
-- ---------

-- LaTeX
Plug 'lervag/vimtex'

-- GLSL
Plug 'tikhomirov/vim-glsl'

-- Bazel
Plug 'google/vim-maktaba'
Plug 'bazelbuild/vim-bazel'

-- Flatbuffers
Plug 'zchee/vim-flatbuffers'

-- Markdown
Plug('iamcco/markdown-preview.nvim', { ['do'] = 'cd app & yarn install' })

-- }}}

vim.call('plug#end')

-- }}}

-- Configuration {{{1
-- -------------

local util = require('util')

util.load_config('colorscheme.vim')
util.load_config('editor_options.lua')
util.load_config('keymaps.vim')

util.load_config('plugins/airline.vim')
util.load_config('plugins/bufkill.vim')
util.load_config('plugins/compe.lua')
util.load_config('plugins/doge.lua')
util.load_config('plugins/fzf.vim')
util.load_config('plugins/gitsigns.lua')
util.load_config('plugins/gundo.vim')
util.load_config('plugins/highlightedyank.vim')
util.load_config('plugins/lspconfig.lua')
util.load_config('plugins/lspkind.lua')
util.load_config('plugins/nerdtree.lua')
util.load_config('plugins/nvim_lightbulb.lua')
util.load_config('plugins/search_pulse.vim')
util.load_config('plugins/startify.vim')
util.load_config('plugins/subversive.vim')
util.load_config('plugins/tabular.vim')
util.load_config('plugins/tmuxline.lua')
util.load_config('plugins/tmux_navigator.vim')
util.load_config('plugins/treesitter.lua')
util.load_config('plugins/trouble.lua')
util.load_config('plugins/vista.vim')
util.load_config('plugins/vsnip.lua')

-- }}}

-- init.lua logistics {{{1
-- ------------------

-- Source local configuration files if they exist
util.load_config_if_present('init.local.vim')
util.load_config_if_present('init.local.lua')

-- Reload init.lua automatically after writing to it
util.load_config('reload.vim')

-- }}}
