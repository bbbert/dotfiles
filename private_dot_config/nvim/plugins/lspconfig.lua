local util = require('util')

local buf_get_clients_table = function(bufnr)
  local clients = vim.lsp.buf_get_clients(bufnr)
  local clients_table = {}
  for _, client in pairs(clients) do
    clients_table[client.name] = client
  end
  return clients_table
end

_G.lsp_organize_imports = function()
  local clients = buf_get_clients_table(0)
  if clients['pyright'] ~= nil then
    vim.lsp.buf.execute_command({
      command = "pyright.organizeimports",
      arguments = { vim.uri_from_bufnr(0) },
    })
  elseif clients['tsserver'] ~= nil then
    vim.lsp.buf.execute_command({
      command = "_typescript.organizeImports",
      arguments = { vim.uri_from_bufnr(0) },
    })
  end
end

_G.format_range_operator = function()
  local old_func = vim.go.operatorfunc
  _G.op_func_formatting = function()
    local start = vim.api.nvim_buf_get_mark(0, '[')
    local finish = vim.api.nvim_buf_get_mark(0, ']')
    vim.lsp.buf.range_formatting({}, start, finish)
    vim.go.operatorfunc = old_func
    _G.op_func_formatting = nil
  end
  vim.go.operatorfunc = 'v:lua.op_func_formatting'
  vim.api.nvim_feedkeys('g@', 'n', false)
end

_G.lsp_switch_source_header = function(splitcmd)
  local params = { uri = vim.uri_from_bufnr(0) }
  vim.lsp.buf_request(0, 'textDocument/switchSourceHeader', params, function(err, _, result)
    if err then return end
    if not result then print("Corresponding file can’t be determined") return end
    vim.api.nvim_command(splitcmd .. ' ' .. vim.uri_to_fname(result))
  end)
end

-- Setup keymaps
local on_attach = function(client, bufnr)
  if client == nil then
    return
  end

  -- Mappings.
  util.buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>')
  util.buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>')
  util.buf_set_keymap('n', 'gi', '<Cmd>lua vim.lsp.buf.implementation()<CR>')
  util.buf_set_keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>')
  util.buf_set_keymap('n', 'gt', '<Cmd>lua vim.lsp.buf.type_definition()<CR>')
  util.buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>')
  util.buf_set_keymap('n', '<C-k>', '<Cmd>lua vim.lsp.buf.signature_help()<CR>')
  util.buf_set_keymap('n', '<Leader>wa', '<Cmd>lua vim.lsp.buf.add_workspace_folder()<CR>')
  util.buf_set_keymap('n', '<Leader>wr', '<Cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>')
  util.buf_set_keymap('n', '<Leader>wl', '<Cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>')
  util.buf_set_keymap('n', '<Leader>cr', '<Cmd>lua vim.lsp.buf.rename()<CR>')
  util.buf_set_keymap('n', '<Leader>ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>')
  util.buf_set_keymap('n', '[d', '<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
  util.buf_set_keymap('n', ']d', '<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
  util.buf_set_keymap('n', '<Leader>dd', '<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>')

  if client.resolved_capabilities.document_formatting then
    util.buf_set_keymap("n", "<F3>", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
  end
  if client.resolved_capabilities.document_range_formatting then
    util.buf_set_keymap("x", "<F3>", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>")
    util.buf_set_keymap("n", "gm", "<Cmd>lua format_range_operator()<CR>")
  end
  util.buf_set_keymap('n', '<F4>', '<Cmd>lua lsp_organize_imports()<CR>')
  util.buf_set_keymap('n', 'gs', '<Cmd>lua lsp_switch_source_header("edit")<CR>')
end

local make_base_config = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true

  return {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 100,
    },
  }
end

-- List of servers to initialize with the base config, unless they are overriden
-- by a server-specific config in <server_override_dir>/<server>.lua
local default_servers = {
  'bashls',
  'clangd',
  'pyright',
  'rust_analyzer',
  'terraformls',
  'texlab',
  'tsserver',
}

-- Server-specific config overrides
local server_override_dir = vim.fn.stdpath('config') .. '/plugins/lspconfig'
local server_overrides = vim.fn.globpath(server_override_dir, '*.lua', 0, 1)
local local_server_overrides = vim.fn.globpath(server_override_dir, '*.local.lua', 0, 1)

local function get_server_override_config(server_override_path)
  local filename = vim.fn['maktaba#path#Basename'](server_override_path)
  local lsp = vim.fn.split(filename, '\\.')[1]

  local server_module = dofile(server_override_path)
  if util.is_callable(server_module.modify_base_config) then
    local config = server_module.modify_base_config(make_base_config())
    return lsp, config
  end
  return lsp, nil
end

local server_configs = {}

-- Start with default configs
for _, lsp in ipairs(default_servers) do
  server_configs[lsp] = make_base_config()
end

-- Override with server-specific configs
for _, server_override_path in ipairs(server_overrides) do
  local lsp, config = get_server_override_config(server_override_path)
  if config ~= nil then
    server_configs[lsp] = config
  end
end

-- Override with local server-specific overrides first
for _, server_override_path in ipairs(local_server_overrides) do
  local lsp, config = get_server_override_config(server_override_path)
  if config ~= nil then
    server_configs[lsp] = config
  end
end

-- Finally, actually setup the servers
for lsp, config in pairs(server_configs) do
  require('lspconfig')[lsp].setup(config)
end

require('fzf_lsp').setup()
