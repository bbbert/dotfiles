local util = {}

-- force loading a module
-- useful for enabling nvim configuration auto-reloading
function util.force_require(module)
  if package.loaded[module] ~= nil then
    package.loaded[module] = nil
  end
  return require(module)
end

local config_path = vim.fn.stdpath('config') .. '/'

-- source a file and error if it does not exist
function util.load_config(config_subpath)
  local path = config_path .. config_subpath
  vim.cmd('source ' .. path)
end

-- source a file but don't error if it does not exist
function util.load_config_if_present(config_subpath)
  local path = config_path .. config_subpath
  if vim.fn.filereadable(path) == 1 then
    vim.cmd('source ' .. path)
  end
end

return util
