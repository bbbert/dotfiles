let g:vista_fzf_preview = ['right:50%']

" Add to statusline
function! NearestMethodOrFunction() abort
  let s:font = get(g:, 'airline_powerline_fonts', 0)
  let s:function_icon = s:font ? ' Ⓕ  ' : ''
  let s:nearest_method = get(b:, 'vista_nearest_method_or_function', '')
  if !empty(s:nearest_method)
    return s:function_icon . s:nearest_method
  endif
  return ''
endfunction
set statusline+=%{NearestMethodOrFunction()}

" By default vista.vim never runs if you don't call it explicitly.
"
" If you want to show the nearest function in your statusline automatically,
" you can add the following line to your vimrc
autocmd VimEnter * call vista#RunForNearestMethodOrFunction()
