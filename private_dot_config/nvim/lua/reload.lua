local M = {}

M.pre_reload = {}
M.post_reload = {}

function M.pre_reload_hook(key, fn)
  if type(fn) ~= 'function' then
    error('pre-reload hook must be a function')
  end
  M.pre_reload[key] = fn
end

function M.post_reload_hook(key, fn)
  if type(fn) ~= 'function' then
    error('post-reload hook must be a function')
  end
  M.post_reload[key] = fn
end

function M.reload()
  for _, fn in pairs(M.pre_reload) do
    fn()
  end

  vim.cmd "source $MYVIMRC"

  for _, fn in pairs(M.post_reload) do
    fn()
  end
end

function M.setup() 
  -- Reload init.lua automatically after writing to anything in the config directory
  vim.cmd [[
    augroup reloadInit
      autocmd!
      autocmd BufWritePost **/.config/nvim/* lua require('reload').reload()
    augroup END
  ]]
end

return M
