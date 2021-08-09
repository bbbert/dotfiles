" Use powerline fonts
let g:airline_powerline_fonts = 1

" Show message about trailing whitespaces
let g:airline#extensions#whitespace#enabled = 1

" Integration with tmuxline: update tmux when colours are changed
let g:airline#extensions#tmuxline#enabled = 1

" Integration with vim-zoom
function! CheckZoomed()
  if exists('g:loaded_zoom') && zoom#statusline() == "zoomed"
    return "[Z]"
  endif
  return ""
endfunction

" Show [+] beside modified files
let g:airline_detect_modified = 1

" Airline buffer numbers work like tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <Leader>1 <Plug>AirlineSelectTab1
nmap <Leader>2 <Plug>AirlineSelectTab2
nmap <Leader>3 <Plug>AirlineSelectTab3
nmap <Leader>4 <Plug>AirlineSelectTab4
nmap <Leader>5 <Plug>AirlineSelectTab5
nmap <Leader>6 <Plug>AirlineSelectTab6
nmap <Leader>7 <Plug>AirlineSelectTab7
nmap <Leader>8 <Plug>AirlineSelectTab8
nmap <Leader>9 <Plug>AirlineSelectTab9
nmap <Leader>- <Plug>AirlineSelectPrevTab
nmap <Leader>= <Plug>AirlineSelectNextTab

" Customize airline
function! AirlineInit()
  if exists('g:loaded_airline')
    call airline#parts#define_function('zoomed', 'CheckZoomed')
    let g:airline_section_c = airline#section#create(['file', 'zoomed', 'readonly'])
  endif
endfunction

" Call airline customization functions once airline is loaded
augroup airlineInit
  autocmd!
  autocmd VimEnter * call AirlineInit()
augroup END
