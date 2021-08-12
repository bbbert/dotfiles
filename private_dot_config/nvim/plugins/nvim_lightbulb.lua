require('nvim-lightbulb').update_lightbulb {
  sign = {
    enabled = true,
    priority = 10,
  },
}

vim.cmd [[autocmd CursorHold,CursorHoldI * lua require('nvim-lightbulb').update_lightbulb()]]
