-- General configuration {{{1
-- ---------------------

vim.opt.termguicolors = true                   -- Use terminal colours

vim.opt.number = true                          -- Line numbers
vim.opt.cursorline = true                      -- Highlight current line
vim.opt.backspace = {'indent', 'eol', 'start'} -- Enable backspace
vim.opt.history = 1024                         -- Many lines of history
vim.opt.autoread = true                        -- Reload files that have changed
vim.opt.lazyredraw = true                      -- Redraw only when needed, not during macros
vim.opt.modeline = true                        -- Respect modelines
vim.opt.timeoutlen = 300                       -- Don't wait so long for prefix commands

-- }}}

-- Mouse {{{1
-- -----

vim.opt.mouse = 'a' -- Enable mouse in all modes

-- }}}

-- Search {{{1
-- ------

vim.opt.incsearch = true  -- Enable incremental searching
vim.opt.hlsearch = true   -- Highlight searches
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true  -- But only if the search pattern was lowercase

-- }}}

-- Swap & backup {{{1
-- -------------

vim.opt.swapfile = false    -- Disable swapfiles

vim.opt.backup = true       -- Keep a backup of file
vim.opt.writebackup = true
vim.opt.backupcopy = 'auto' -- Do what's best to backup files
vim.opt.backupdir = {       -- Directories to backup to
  '~/.vim-tmp',
  '~/.tmp',
  '~/tmp,/tmp',
}
vim.opt.backupskip = '/tmp' -- Don't write a backup if in the tmp directory

-- }}}

-- Indentation & display {{{1
-- ---------------------

-- 2 spaces per indent level, replace tabs with spaces
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.tabstop = 2
vim.opt.expandtab = true

vim.opt.list = true
vim.opt.listchars = {                -- Show tabs and trailing spaces
  tab = '|·',
  trail = '·',
}
vim.opt.wrap = false                 -- Don't wrap lines
vim.opt.textwidth = 0                -- Set textwidth to 0 to prevent hard wrapping

vim.opt.shortmess = 'filmnrxtToOFIc' -- Configure messages to be short

-- }}}

-- Scrolling {{{1
-- ---------

vim.opt.scrolloff = 8     -- Start scrolling when getting close to borders
vim.opt.sidescroll = 1    -- Wrap is off, so scroll sideways too
vim.opt.sidescrolloff = 8 -- In case lines are really long

-- }}}

-- Folding {{{1
-- -------

vim.opt.foldmethod = 'marker' -- Fold according to marker

-- }}}

-- Completion {{{1
-- ----------

vim.opt.wildmode = { 'longest', 'full' } -- Complete it first, then show all matches
vim.opt.wildmenu = true                  -- Show menu
vim.opt.wildoptions = 'pum'              -- Show menu
vim.opt.completeopt = {
  'menuone',
  'noinsert',
  'noselect',
}

-- }}}
