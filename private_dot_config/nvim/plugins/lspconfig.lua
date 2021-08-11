local util = require('util')

-- Setup keymaps
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  -- Mappings.
  local opts = { noremap = true, silent = true }

  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<Space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<Space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<Space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<Space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<Space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<Space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<Space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)

  -- Symbol outline
  -- buf_set_keymap('n', '<Leader>o', ':SymbolsOutline<CR>', opts)

  if client ~= nil then
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    elseif client.resolved_capabilities.document_range_formatting then
        buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end
  end
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
  pyright = make_base_config(),
  rust_analyzer = make_base_config(),
  sumneko_lua = sumneko_lua_config(make_base_config()),
  tsserver = make_base_config(),
}

for lsp, config in pairs(server_configs) do
  require('lspconfig')[lsp].setup(config)
end
