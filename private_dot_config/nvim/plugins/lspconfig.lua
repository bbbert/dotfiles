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

  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings.
  local opts = { noremap = true, silent = true }
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<leader>cr', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

  if client.resolved_capabilities.document_formatting then
    buf_set_keymap("n", "<F3>", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  end
  if client.resolved_capabilities.document_range_formatting then
    buf_set_keymap("x", "<F3>", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    buf_set_keymap("n", "gm", "<cmd>lua format_range_operator()<CR>", opts)
  end
  buf_set_keymap('n', '<F4>', '<cmd>lua lsp_organize_imports()<CR>', opts)
  buf_set_keymap('n', 'gs', '<cmd>lua lsp_switch_source_header("edit")<CR>', opts)
end

-- Special LSP config for neovim Lua development
local sumneko_lua_config = function(base_config)
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

-- Special HTML config
local html_config = function(base_config)
  local cmd = util.first_executable_command {
    'vscode-html-language-server',
    'vscode-html-languageserver',
  }
  if cmd == nil then
    return
  end

  local config = util.deepcopy(base_config)
  config.cmd = { cmd, '--stdio' }
  return config
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

local server_configs = {
  bashls = make_base_config(),
  clangd = make_base_config(),
  html = html_config(make_base_config()),
  pyright = make_base_config(),
  rust_analyzer = make_base_config(),
  sumneko_lua = sumneko_lua_config(make_base_config()),
  terraformls = make_base_config(),
  texlab = make_base_config(),
  tsserver = make_base_config(),
}

for lsp, config in pairs(server_configs) do
  require('lspconfig')[lsp].setup(config)
end

require('fzf_lsp').setup()
