local M = {}

function M.modify_base_config(base_config)
  return require('lua-dev').setup { lspconfig = base_config }
end

return M
