local M = {}

local config_path = vim.fn.stdpath('config')

-- Source a file and error if it does not exist
function M.source(config_subpath)
  local path = config_path .. '/' .. config_subpath
  vim.cmd('source ' .. path)
end

-- Source a file only if it exists
function M.source_if_present(config_subpath)
  local path = config_path .. '/' .. config_subpath
  if vim.fn.filereadable(path) == 1 then
    vim.cmd('source ' .. path)
  end
end

-- Deep copy a table
function M.deepcopy(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == 'table' then
    copy = {}
    for orig_key, orig_value in next, orig, nil do
      copy[M.deepcopy(orig_key)] = M.deepcopy(orig_value)
    end
    setmetatable(copy, M.deepcopy(getmetatable(orig)))
  else
    copy = orig
  end
  return copy
end

vim.cmd [[
  function! CommandIsExecutable(command)
    call system('command -v ' . a:command)
    return v:shell_error == 0
  endfunction
]]

-- Check if a system command is executable
function M.is_executable(command)
  return vim.fn.CommandIsExecutable(command) ~= 0
end

-- return first executable command
function M.first_executable_command(commands)
  for _, potential_command in ipairs(commands) do
    if M.is_executable(potential_command) then
      return potential_command
    end
  end
  return nil
end

-- set silent, noremap global keymap
function M.global_set_keymap(mode, keymap, command)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_set_keymap(mode, keymap, command, opts)
end

-- set silent, noremap keymap on current buffer
function M.buf_set_keymap(mode, keymap, command)
  local opts = { noremap = true, silent = true }
  vim.api.nvim_buf_set_keymap(0, mode, keymap, command, opts)
end

-- check if an object is callable
function M.is_callable(object)
  if type(object) == 'function' then
    return true
  elseif type(object) == 'table' then
    local meta = getmetatable(object)
    return type(meta) == 'table' and type(meta.__call) == 'function'
  else
    return false
  end
end

return M
