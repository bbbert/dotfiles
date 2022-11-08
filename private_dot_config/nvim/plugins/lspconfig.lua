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
  vim.lsp.buf_request(0, 'textDocument/switchSourceHeader', params, function(err, result)
    if err then return end
    if not result then
      print("Corresponding file can’t be determined")
      return
    end
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

  util.buf_set_keymap('n', '<F4>', '<Cmd>lua lsp_organize_imports()<CR>')
  util.buf_set_keymap('n', 'gs', '<Cmd>lua lsp_switch_source_header("edit")<CR>')
end

util.global_set_keymap("n", "<F3>", "<Cmd>lua vim.lsp.buf.formatting()<CR>")
util.global_set_keymap("x", "<F3>", "<Cmd>lua vim.lsp.buf.range_formatting()<CR>")
util.global_set_keymap("n", "gm", "<Cmd>lua format_range_operator()<CR>")

local make_base_config = function()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  require('cmp_nvim_lsp').default_capabilities(capabilities)

  return {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 100,
    },
  }
end

-- Load server-specific config overrides from a folder
local function load_server_overrides(dir, pattern)
  local overrides = {}

  local server_override_paths = vim.fn.globpath(dir, pattern, 0, 1)
  for _, server_override_path in ipairs(server_override_paths) do
    local filename = vim.fn['maktaba#path#Basename'](server_override_path)
    local lsp = vim.fn.split(filename, '\\.')[1]

    local override_module = dofile(server_override_path)
    if util.is_callable(override_module.modify_base_config) then
      local config = override_module.modify_base_config(make_base_config())
      overrides[lsp] = config
    else
      print('Failed to load server override ' .. server_override_path)
    end
  end

  return overrides
end

local server_override_dir = vim.fn.stdpath('config') .. '/plugins/lspconfig'
local server_overrides = load_server_overrides(server_override_dir, '*.lua')
local local_server_overrides = load_server_overrides(server_override_dir, '*.local.lua')

local function get_config_by_server_name(server_name)
  if local_server_overrides[server_name] ~= nil then
    return local_server_overrides[server_name]
  elseif server_overrides[server_name] ~= nil then
    return server_overrides[server_name]
  end
  return make_base_config()
end

local lsp_installer = require('nvim-lsp-installer')

-- Register a handler that will be called for each installed server when it's
-- ready (i.e. when installation is finished or if the server is already
-- installed).
lsp_installer.on_server_ready(function(server)
  local opts = get_config_by_server_name(server.name)
  server:setup(opts)
end)
