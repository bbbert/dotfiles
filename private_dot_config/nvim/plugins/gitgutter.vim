let g:gitgutter_map_keys = 0                        " Let me map my own keys
let g:gitgutter_max_signs = 1024                    " Allow more signs by default
let g:gitgutter_override_sign_column_highlight = 0

" Remap next hunk command
nmap ]h <Plug>(GitGutterNextHunk)
" Remap previous hunk command
nmap [h <Plug>(GitGutterPrevHunk)
" Stage hunk
nmap <Leader>hs <Plug>(GitGutterStageHunk)
" Revert hunk
nmap <Leader>hr <Plug>(GitGutterUndoHunk)

" Toggle folding on diffs
nmap <Leader>hf :GitGutterFold<CR>
