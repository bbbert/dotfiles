" Make full text search happen only on file contents instead of also file name
command! -bang -nargs=* Ag call fzf#vim#ag(<q-args>, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)
command! -bang -nargs=* Rg call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case ' . shellescape(<q-args>), 1, fzf#vim#with_preview({'options': '--delimiter : --nth 4..'}), <bang>0)

" Fuzzy case-insensitive filename search on current word under cursor
command! -bang -nargs=? -complete=dir FilesWord call fzf#vim#files(<q-args>, {'options': '-i --query '.expand('<cword>')}, <bang>0)
command! -bang -nargs=? GFilesWord call fzf#vim#gitfiles(<q-args>, {'options': '-i --query '.expand('<cword>')}, <bang>0)

" Switch to other split before executing command if inside the NERD tree.
function! Do_outside_NERD(command)
    return (expand('%') =~ 'NERD_tree' ? "\<C-W>\<C-W>" : '') . a:command
endfunction

" Fuzzy matching on filenames in cwd
nnoremap <expr> <Leader>p Do_outside_NERD(":Files\<CR>")

" Fuzzy case-insensitive filename search on current word under cursor in cwd
nnoremap <expr> <Leader>wp Do_outside_NERD(":FilesWord\<CR>")

" Fuzzy matching on filenames in Git repo
nnoremap <expr> <Leader>g Do_outside_NERD(":GFiles\<CR>")

" Fuzzy case-insensitive filename search on current word under cursor in Git repo
nnoremap <expr> <Leader>wg Do_outside_NERD(":GFilesWord\<CR>")

" Full text search in cwd
nnoremap <expr> <Leader>f Do_outside_NERD(":Rg\<CR>")

" Full text search in cwd on current word under cursor
nnoremap <expr> <Leader>wf Do_outside_NERD(":Rg \<C-r>\<C-w>\<CR>")

" Search among the currently open buffers
nnoremap <expr> <Leader>b Do_outside_NERD(":Buffers\<CR>")

" Make it easier to browse the completion window
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
