local util = require('util')

require('trouble').setup {}

-- Toggle diagnostics, the current file only by default
util.global_set_keymap('n', 'gx', '<Cmd>TroubleToggle<CR>')

-- Show diagnostics for the whole workspace
util.global_set_keymap('n', 'gwx', '<Cmd>TroubleToggle workspace_diagnostics<CR>')
