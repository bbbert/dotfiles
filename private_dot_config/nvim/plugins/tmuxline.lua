function tmux_window_indicator_format()
  local any_condition = '#{||:#{||:#{window_zoomed_flag},#{window_activity_flag}},#{window_bell_flag}}'
  local left = '#{?' .. any_condition .. ', [,}'
  local right = '#{?' .. any_condition .. ',],}'
  local zoomed = '#{?window_zoomed_flag,Z,}'
  local activity = '#{?window_activity_flag,*,}'
  local bell = '#{?window_bell_flag,!,}'

  return '#I:#W' .. left .. zoomed .. activity .. bell .. right
end

vim.g.tmuxline_preset = {
  a = '#S:#I.#P',
  b = '#H',
  win = tmux_window_indicator_format(),
  cwin = tmux_window_indicator_format(),
  y = { '%a', '%Y/%m/%d', '%H:%M' },
}

function maybe_update_tmuxline_conf_from_tmuxline()
  if vim.fn.exists(':TmuxlineSnapshot') == 0 then
    return
  end

  local tmp_path = '/tmp/.tmux.tmuxline.conf'
  local target_path = vim.fn.expand('$HOME/.tmux.tmuxline.conf')

  -- Run tmuxline into a temporary file and read the results
  vim.cmd("execute ':TmuxlineSnapshot! " .. tmp_path .. "'")
  local tmp_file = io.open(tmp_path, 'r')
  if tmp_file == nil then
    return
  end
  local tmp_contents = tmp_file:read('*a')
  tmp_file:close()

  local target_file = io.open(target_path, 'r')
  local target_contents = ''
  if target_file ~= nil then
    target_contents = target_file:read('*a')
    target_file:close()
  end

  -- Copy result to the target file if contents have changed
  if target_contents ~= tmp_contents then
    target_file = io.open(target_path, 'w')
    target_file:write(tmp_contents)
    target_file:close()
  end
end

-- Update ~/.tmux.tmuxline.conf if it differs from the configuration that
-- tmuxline.vim generates
maybe_update_tmuxline_conf_from_tmuxline()
