require('gitsigns').setup {
  signs = {
    add          = { hl = 'GitSignsAdd',    text = '│', numhl = 'GitSignsAddNr'   , linehl = 'GitSignsAddLn' },
    change       = { hl = 'GitSignsChange', text = '│', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
    changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
  },
  numhl = true,
  keymaps = {
    -- Default keymap options
    noremap = true,

    ['n ]h'] = { expr = true, "&diff ? ']c' : '<cmd>lua require\"gitsigns.actions\".next_hunk()<CR>'"},
    ['n [h'] = { expr = true, "&diff ? '[c' : '<cmd>lua require\"gitsigns.actions\".prev_hunk()<CR>'"},

    ['n <Leader>hs'] = '<Cmd>lua require"gitsigns".stage_hunk()<CR>',
    ['v <Leader>hs'] = '<Cmd>lua require"gitsigns".stage_hunk({ vim.fn.line("."), vim.fn.line("v") })<CR>',
    ['n <Leader>hu'] = '<Cmd>lua require"gitsigns".undo_stage_hunk()<CR>',
    ['n <Leader>hr'] = '<Cmd>lua require"gitsigns".reset_hunk()<CR>',
    ['v <Leader>hr'] = '<Cmd>lua require"gitsigns".reset_hunk({ vim.fn.line("."), vim.fn.line("v") })<CR>',
    ['n <Leader>hR'] = '<Cmd>lua require"gitsigns".reset_buffer()<CR>',
    ['n <Leader>hp'] = '<Cmd>lua require"gitsigns".preview_hunk()<CR>',
    ['n <Leader>hb'] = '<Cmd>lua require"gitsigns".blame_line(true)<CR>',

    -- Text objects
    ['o ih'] = ':<C-u>lua require"gitsigns.actions".select_hunk()<CR>',
    ['x ih'] = ':<C-u>lua require"gitsigns.actions".select_hunk()<CR>',
  },
}
