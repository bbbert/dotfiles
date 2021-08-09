let g:gundo_width = 30
let g:gundo_right = 1
let g:gundo_help = 0
let g:gundo_close_on_revert = 1
let g:gundo_prefer_python3 = 1

" Show infinite undo window
nnoremap <Leader>u :<C-u>GundoToggle<CR>
