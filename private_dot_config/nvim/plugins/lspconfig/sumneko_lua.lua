local M = {}

function M.modify_base_config(base_config)
  return require('neodev').setup { lspconfig = base_config }
end

return M
