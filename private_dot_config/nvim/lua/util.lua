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

-- deep copy a table
function util.deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[util.deepcopy(orig_key)] = util.deepcopy(orig_value)
    end
    setmetatable(copy, util.deepcopy(getmetatable(orig)))
  else
    copy = orig
  end
  return copy
end

-- check if command is executable
function util.is_executable(command)
  vim.cmd [[
    function! CommandIsExecutable(command)
      call system('which ' . a:command)
      return v:shell_error == 0
    endfunction
  ]]
  return vim.fn.CommandIsExecutable(command) ~= 0
end

-- return first executable command
function util.first_executable_command(commands)
  for _, potential_command in ipairs(commands) do
    if util.is_executable(potential_command) then
      return potential_command
    end
  end
  return nil
end

return util
