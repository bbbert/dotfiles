" Replace things matching range 1 within range 2 with the contents of the prompt.
nmap <leader>s <plug>(SubversiveSubstituteRange)
xmap <leader>s <plug>(SubversiveSubstituteRange)

" Replace things matching the word around the cursor within the second range
" provided with the contents of the prompt.
nmap <leader>ss <plug>(SubversiveSubstituteWordRange)

" Subvert things matching range 1 within range 2 with the contents of the prompt.
nmap <leader><leader>s <plug>(SubversiveSubvertRange)
xmap <leader><leader>s <plug>(SubversiveSubvertRange)

" Subvert things matching the word around the cursor within the second range
" provided with the contents of the prompt.
nmap <leader><leader>ss <plug>(SubversiveSubvertWordRange)
