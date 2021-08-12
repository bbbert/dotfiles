local util = require('util')

vim.g.NERDTreeFileExtensionHighlightFullName = 1
vim.g.NERDTreeExactMatchHighlightFullName = 1
vim.g.NERDTreePatternMatchHighlightFullName = 1

-- Open project dir explorer
util.global_set_keymap('n', '<Leader>nn', ':NERDTreeToggle<CR>')
util.global_set_keymap('n', '<Leader>nf', ':NERDTreeFind<CR>')
