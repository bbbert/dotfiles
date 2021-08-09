local util = {}

function util.values(t)
  local i = 0
  return function() i = i + 1; return t[i] end
end

local config_path = vim.fn.stdpath('config') .. '/'

function util.load_config(config_subpath)
  local path = config_path .. config_subpath
  vim.cmd('source ' .. path)
end

function util.load_config_if_present(config_subpath)
  local path = config_path .. config_subpath
  if vim.fn.filereadable(path) == 1 then
    vim.cmd('source ' .. path)
  end
end

return util
