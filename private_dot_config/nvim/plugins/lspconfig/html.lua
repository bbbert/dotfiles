local M = {}

local util = require('util')

function M.modify_base_config(base_config)
  local cmd = util.first_executable_command {
    'vscode-html-language-server',
    'vscode-html-languageserver',
  }
  if cmd == nil then
    return
  end

  local config = util.deepcopy(base_config)
  config.cmd = { cmd, '--stdio' }
  return config
end

return M
