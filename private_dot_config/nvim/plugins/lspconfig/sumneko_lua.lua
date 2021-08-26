local M = {}

local util = require('util')

function M.modify_base_config(base_config)
  -- set the path to the sumneko installation
  local sumneko_root_path = '/usr/share/lua-language-server'
  local sumneko_binary = '/usr/bin/lua-language-server'

  -- skip if we cannot find the binary
  if (vim.fn.filereadable(sumneko_binary) == 0
      or vim.fn.isdirectory(sumneko_root_path) == 0) then
    return nil
  end

  local config = util.deepcopy(base_config)
  config.cmd = { sumneko_binary, '-E', sumneko_root_path .. '/main.lua' }
  return require('lua-dev').setup { lspconfig = config }
end

return M
