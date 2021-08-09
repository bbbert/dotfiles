if !exists('*ReloadInit')
  function! ReloadInit() abort
    source $MYVIMRC

    if exists('g:loaded_airline')
      execute ':AirlineRefresh'
    endif

    " fix brackets around devicons after re-sourcing vimrc
    " https://github.com/ryanoasis/vim-devicons/issues/154
    if exists('g:loaded_webdevicons')
      call webdevicons#refresh()
    endif
  endfunction
endif

" Reload init.lua automatically after writing to it
augroup reloadInit
  autocmd!
  autocmd BufWritePost $MYVIMRC,**/.config/nvim/*,**/.config/nvim/**/* call ReloadInit()
augroup END
