vim.g.vsnip_snippet_dirs = {
  vim.fn.expand('~/.vsnip'),
  vim.fn.expand('~/.vsnip.local'),
}

-- identify certain filetypes with others
vim.g.vsnip_filetypes = {
  javascriptreact = { 'javascript' },
  typescriptreact = { 'typescript' },
}
