local util = require('util')

require('trouble').setup {
  mode = 'lsp_document_diagnostics',
}

-- Toggle diagnostics, the current file only by default
util.buf_set_keymap('n', '<leader>dd', '<cmd>TroubleToggle<CR>')

-- Show diagnostics for the current file only
util.buf_set_keymap('n', '<leader>df', '<cmd>TroubleToggle lsp_document_diagnostics<CR>')

-- Show diagnostics for the whole workspace
util.buf_set_keymap('n', '<leader>dw', '<cmd>TroubleToggle lsp_workspace_diagnostics<CR>')

-- Show references for the word under the cursor
util.buf_set_keymap('n', '<leader>dr', '<cmd>TroubleToggle references<CR>')
