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

-- Themes for airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

-- Sync tmux config with Airline config
Plug 'edkolev/tmuxline.vim'

-- Gitsigns
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim' -- needs nvim-lua/plenary.nvim

-- Neotree
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'

-- Bufkill
Plug 'qpkorr/vim-bufkill'

-- Gundo
Plug 'sjl/gundo.vim'

-- Fuzzy finder
Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'

-- Telescope (still too slow to replace fzf but can be used for other pickers)
Plug 'nvim-telescope/telescope.nvim'
Plug('nvim-telescope/telescope-fzf-native.nvim', { ['do'] = 'make' })

-- Seamless split navigation with tmux
Plug 'christoomey/vim-tmux-navigator'

-- }}}

-- LSP {{{2
-- ---

-- LSP configs
Plug 'neovim/nvim-lspconfig'

-- LSP installer
Plug 'williamboman/nvim-lsp-installer'

-- Null LS for linters
Plug 'jose-elias-alvarez/null-ls.nvim'

-- Icons for LSP completion
Plug 'onsails/lspkind-nvim'

-- Diagnostics
Plug 'folke/trouble.nvim'

-- Lightbulb beside code actions
Plug 'kosayoda/nvim-lightbulb'

-- Symbol outliner
Plug 'simrat39/symbols-outline.nvim'

-- }}}

-- Completion {{{2
-- ----------

-- Completion engine
Plug 'hrsh7th/nvim-cmp'

-- Completion sources
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

-- }}}

-- Code tools {{{2
-- ----------

-- Treesitter
Plug('nvim-treesitter/nvim-treesitter', { ['do'] = ':TSUpdate' })

-- Documentation generator
Plug('kkoomen/vim-doge', { ['do'] = ':call doge#install()' })

-- GitHub Integration
Plug 'pwntester/octo.nvim'

-- Diff
Plug 'sindrets/diffview.nvim'

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

-- Improved asterisk
Plug 'haya14busa/vim-asterisk'

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

-- Vimwiki
Plug 'vimwiki/vimwiki'

-- Lua dev in neovim
Plug 'folke/lua-dev.nvim'

-- }}}

vim.call('plug#end')

-- }}}

-- Configuration {{{1
-- -------------

local util = require('util')

util.source 'editor/colorscheme.vim'
util.source 'editor/options.lua'
util.source 'editor/keymaps.vim'

util.source 'plugins/airline.vim'
util.source 'plugins/bufkill.vim'
util.source 'plugins/diffview.lua'
util.source 'plugins/doge.lua'
util.source 'plugins/fzf.vim'
util.source 'plugins/gitsigns.lua'
util.source 'plugins/gundo.vim'
util.source 'plugins/highlightedyank.vim'
util.source 'plugins/lspconfig.lua'
util.source 'plugins/neo_tree.lua'
util.source 'plugins/null_ls.lua'
util.source 'plugins/nvim_cmp.lua'
util.source 'plugins/nvim_lightbulb.lua'
util.source 'plugins/octo.lua'
util.source 'plugins/search.vim'
util.source 'plugins/startify.vim'
util.source 'plugins/subversive.vim'
util.source 'plugins/symbols_outline.lua'
util.source 'plugins/tabular.vim'
util.source 'plugins/telescope.lua'
util.source 'plugins/tmuxline.lua'
util.source 'plugins/tmux_navigator.vim'
util.source 'plugins/treesitter.lua'
util.source 'plugins/trouble.lua'
util.source 'plugins/vimtex.vim'

-- }}}

-- init.lua logistics {{{1
-- ------------------

-- Source local configuration files if they exist
util.source_if_present 'init.local.vim'
util.source_if_present 'init.local.lua'

-- Reload init.lua automatically after writing to it
require('reload').setup()

-- }}}
