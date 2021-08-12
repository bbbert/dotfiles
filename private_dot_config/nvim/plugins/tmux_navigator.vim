" vim-tmux-navigator split navigation
" -----------------------------------

" Use our custom bindings instead of tmux navigator's default
let g:tmux_navigator_no_mappings = 1

" Make both ` (tmux prefix) and <C-w> (vim default) work.
nnoremap <silent> <C-w>h :TmuxNavigateLeft<CR>
nnoremap <silent> <C-w>j :TmuxNavigateDown<CR>
nnoremap <silent> <C-w>k :TmuxNavigateUp<CR>
nnoremap <silent> <C-w>l :TmuxNavigateRight<CR>
nnoremap <silent> `h :TmuxNavigateLeft<CR>
nnoremap <silent> `j :TmuxNavigateDown<CR>
nnoremap <silent> `k :TmuxNavigateUp<CR>
nnoremap <silent> `l :TmuxNavigateRight<CR>

" Split panes with same keybindings as tmux
nnoremap <silent> <C-w>\| <C-w><C-v>
nnoremap <silent> <C-w>- <C-w><C-s>
" nnoremap <silent> `\| <C-w><C-v>
" nnoremap <silent> `- <C-w><C-s>

" Note that this means hjkl-| are not available as marks
