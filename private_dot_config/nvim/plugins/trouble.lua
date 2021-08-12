local util = require('util')

require('trouble').setup {
  mode = 'lsp_document_diagnostics',
}

-- Toggle diagnostics, the current file only by default
util.global_set_keymap('n', '<Leader>dd', '<Cmd>TroubleToggle<CR>')
-- vim.cmd "nnoremap <silent> <Leader>dd <Cmd>TroubleToggle<CR>"

-- Show diagnostics for the current file only
util.global_set_keymap('n', '<Leader>df', '<Cmd>TroubleToggle lsp_document_diagnostics<CR>')

-- Show diagnostics for the whole workspace
util.global_set_keymap('n', '<Leader>dw', '<Cmd>TroubleToggle lsp_workspace_diagnostics<CR>')

-- Show references for the word under the cursor
util.global_set_keymap('n', '<Leader>dr', '<Cmd>TroubleToggle references<CR>')
