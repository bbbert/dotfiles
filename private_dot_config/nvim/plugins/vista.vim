" let g:vista_fzf_preview = ['right:50%']

let g:vista_default_executive = 'nvim_lsp'

" By default vista.vim never runs if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()

nnoremap <silent> <Leader>v :Vista!!<CR>
