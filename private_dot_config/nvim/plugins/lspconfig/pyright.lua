local M = {}

local util = require('util')

function M.modify_base_config(base_config)
  local config = util.deepcopy(base_config)

  config.capabilities.workspace.configuration = true;
  config.settings = {
    python = {
      analysis = {
        diagnosticMode = 'openFilesOnly',
      },
    },
  }

  return config
end

return M
