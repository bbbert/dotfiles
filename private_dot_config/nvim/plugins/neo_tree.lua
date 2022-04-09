vim.g.neo_tree_remove_legacy_commands = 1;

vim.fn.sign_define("DiagnosticSignError",
  { text = " ", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn",
  { text = " ", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo",
  { text = " ", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint",
  { text = "", texthl = "DiagnosticSignHint" })

require('neo-tree').setup {
  window = {
    width = 30,
    mappings = {
      ["<space>"] = "toggle_node",
      ["<2-LeftMouse>"] = "open",
      ["<CR>"] = "open",
      ["o"] = "open",
      ["S"] = "open_split",
      ["s"] = "open_vsplit",
      ["t"] = "open_tabnew",
      ["C"] = "close_node",
      ["a"] = "add",
      ["A"] = "add_directory",
      ["d"] = "delete",
      ["r"] = "rename",
      ["y"] = "copy_to_clipboard",
      ["x"] = "cut_to_clipboard",
      ["p"] = "paste_from_clipboard",
      ["P"] = function(state)
        -- Go to the parent node
        local manager = require('neo-tree.sources.manager')
        local renderer = require('neo-tree.ui.renderer')
        local utils = require('neo-tree.utils')

        local node = state.tree:get_node()
        if not node then return end

        local node_path = node:get_id()
        local node_parent_path, _ = utils.split_path(node_path)

        if not utils.is_subpath(state.path, node_parent_path) then
          state.path = node_parent_path
          manager.navigate(state, node_parent_path, node_parent_path)
        else
          renderer.focus_node(state, node_parent_path)
        end
      end,
      ["c"] = "copy", -- takes text input for destination
      ["m"] = "move", -- takes text input for destination
      ["q"] = "close_window",
      ["R"] = "refresh",
    }
  },
  filesystem = {
    use_libuv_file_watcher = true,
    follow_current_file = true,
  },
}

local util = require('util')
util.global_set_keymap('n', '<Leader>nn', '<Cmd>Neotree toggle<CR>')
util.global_set_keymap('n', '<Leader>nf', '<Cmd>Neotree reveal_force_cwd<CR>')
util.global_set_keymap('n', '<Leader>ng', '<Cmd>Neotree toggle git_status right<CR>')
util.global_set_keymap('n', '<Leader>nb', '<Cmd>Neotree toggle buffers<CR>')
