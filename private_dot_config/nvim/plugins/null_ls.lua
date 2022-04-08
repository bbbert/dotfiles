local null_ls = require('null-ls')
local util = require('util')

-- Potential sources to enable if the corresponding commands are found.
local potential_sources = {
  {
    commands = { "pylint" },
    source = null_ls.builtins.diagnostics.pylint
  },
  {
    commands = { "shellcheck" },
    source = null_ls.builtins.code_actions.shellcheck
  },
  {
    commands = { "yapf", "yapf3" },
    source = null_ls.builtins.formatting.yapf
  },
}

-- Add potential sources to the list if their commands are found.
local sources = {}
for _, potential_source in ipairs(potential_sources) do
  local found_command = nil
  for _, command in ipairs(potential_source.commands) do
    if util.is_executable(command) then
      found_command = command
      break
    end
  end

  if found_command then
    table.insert(sources, potential_source.source.with({ command = found_command }))
  end
end

null_ls.setup { sources = sources }
