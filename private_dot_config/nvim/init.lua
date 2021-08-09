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

-- Filetype icons
Plug 'ryanoasis/vim-devicons'

-- Themes for Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

-- Sync tmux config with airline config
Plug 'edkolev/tmuxline.vim'

-- Git gutter
Plug 'airblade/vim-gitgutter'

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

-- Custom textobjs
Plug 'kana/vim-textobj-user'

Plug 'Julian/vim-textobj-brace'          -- aj/ij for braces
Plug 'beloglazov/vim-textobj-quotes'     -- aq/iq for quotes
Plug 'kana/vim-textobj-datetime'         -- ada/ida for dates
Plug 'kana/vim-textobj-indent'           -- ai/ii, aI/iI for block of lines of similar indentation
Plug 'kana/vim-textobj-line'             -- al/il for current line
Plug 'kana/vim-textobj-function'         -- af/if for current function
Plug 'glts/vim-textobj-comment'          -- ac/ic for comment, aC/iC includes surrounding whitespace
Plug 'whatyouhide/vim-textobj-xmlattr'   -- ax/ix for xml/html attributes

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

-- }}}

-- Languages {{{2
-- ---------

-- LaTeX
--Plug 'lervag/vimtex'

-- Rust
--Plug 'rust-lang/rust.vim'

-- Python semantic highlighting
--Plug('numirias/semshi', {'do' = ':UpdateRemotePlugins'})

-- HTML
--Plug 'alvan/vim-closetag'               " Autoclose HTML/XHTML tags

-- Colorizer
--Plug 'chrisbra/Colorizer'

-- Typescript & TSX
--Plug 'pangloss/vim-javascript'
--Plug 'leafgarland/typescript-vim'
--Plug 'peitalin/vim-jsx-typescript'
--Plug 'suy/vim-context-commentstring'

-- GLSL
--Plug 'tikhomirov/vim-glsl'

-- Bazel
--Plug 'google/vim-maktaba'
--Plug 'bazelbuild/vim-bazel'

-- Flatbuffers
--Plug 'zchee/vim-flatbuffers'

-- Debugging
--Plug 'sakhnik/nvim-gdb', { 'do': ':!./install.sh \| UpdateRemotePlugins' }

-- Documentation
--Plug 'kkoomen/vim-doge'

-- Coq
--Plug 'whonore/Coqtail'

-- Julia
--Plug 'JuliaEditorSupport/julia-vim'

-- Markdown
--Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }

-- Terraform
--Plug 'hashivim/vim-terraform'

-- }}}

vim.call('plug#end')

-- }}}

-- Configuration {{{1
-- -------------

local util = require('util')

util.load_config('editor_options.lua')

util.load_config('plugins/airline.vim')
util.load_config('plugins/bufkill.vim')
util.load_config('plugins/fzf.vim')
util.load_config('plugins/gitgutter.vim')
util.load_config('plugins/gundo.vim')
util.load_config('plugins/highlightedyank.vim')
util.load_config('plugins/nerdtree.vim')
util.load_config('plugins/search_pulse.vim')
util.load_config('plugins/startify.vim')
util.load_config('plugins/tabular.vim')
util.load_config('plugins/tmux_navigator.vim')
util.load_config('plugins/tmuxline.lua')

util.load_config('colorscheme.vim')
util.load_config('keymaps.vim')

-- }}}

-- init.lua logistics {{{1
-- ------------------

-- Source local configuration files if they exist
util.load_config_if_present('init.local.vim')
util.load_config_if_present('init.local.lua')

-- Reload init.lua automatically after writing to it
util.load_config('reload.vim')

-- }}}
