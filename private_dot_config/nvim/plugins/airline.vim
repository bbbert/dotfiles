" Use powerline fonts
let g:airline_powerline_fonts = 1

" Show message about trailing whitespaces
let g:airline#extensions#whitespace#enabled = 1

" Integration with tmuxline: update tmux when colours are changed
let g:airline#extensions#tmuxline#enabled = 1

" Show [+] beside modified files
let g:airline_detect_modified = 1

" Airline buffer numbers work like tabs
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <silent> <Leader>1 <Plug>AirlineSelectTab1
nmap <silent> <Leader>2 <Plug>AirlineSelectTab2
nmap <silent> <Leader>3 <Plug>AirlineSelectTab3
nmap <silent> <Leader>4 <Plug>AirlineSelectTab4
nmap <silent> <Leader>5 <Plug>AirlineSelectTab5
nmap <silent> <Leader>6 <Plug>AirlineSelectTab6
nmap <silent> <Leader>7 <Plug>AirlineSelectTab7
nmap <silent> <Leader>8 <Plug>AirlineSelectTab8
nmap <silent> <Leader>9 <Plug>AirlineSelectTab9
nmap <silent> <Leader>- <Plug>AirlineSelectPrevTab
nmap <silent> <Leader>= <Plug>AirlineSelectNextTab

" Hide neo-tree
let g:airline#extensions#tabline#ignore_bufadd_pat = '!|gundo|neo-tree|startify|tagbar|term://'

" Customize airline
function! AirlineInit()
  " Integration with vim-zoom
  function! AirlineZoom()
    if exists('g:loaded_zoom') && zoom#statusline() == 'zoomed'
      return '[Z]'
    endif
    return ''
  endfunction

  " Integration with gitsigns
  function! AirlineGitsignsStatus()
    if exists('b:gitsigns_status_dict') && exists('b:gitsigns_status')
      let branch = ' ' . b:gitsigns_status_dict['head']
      if b:gitsigns_status == ''
        return branch
      else
        return b:gitsigns_status . ' ' . branch
      endif
    endif
    return ''
  endfunction

  call airline#parts#define_function('zoom', 'AirlineZoom')
  call airline#parts#define_function('gitsigns_status', 'AirlineGitsignsStatus')

  let g:airline_section_b = airline#section#create(['gitsigns_status'])
  let g:airline_section_c = airline#section#create(['file', 'zoom', 'readonly'])
endfunction

" Call airline customization functions once airline is loaded
augroup AirlineInit
  autocmd!
  autocmd VimEnter * call AirlineInit()
augroup END

" Refresh airline after reloading the init configuration
lua << EOF
require('reload').post_reload_hook('airline_refresh', function()
  vim.cmd [[
    if exists(':AirlineRefresh') == 2
      execute ':AirlineRefresh'
    endif
  ]]
end)
EOF
