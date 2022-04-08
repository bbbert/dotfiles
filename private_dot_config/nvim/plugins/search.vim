let g:vim_search_pulse_duration = 100

" keep position within the search
let g:asterisk#keeppos = 1

" asterisk and vim search pulse integration
let g:vim_search_pulse_disable_auto_mappings = 1

map n n<Plug>Pulse
map N N<Plug>Pulse
map * <Plug>(asterisk-z*)<Plug>Pulse
map # <Plug>(asterisk-z#)<Plug>Pulse
map g* <Plug>(asterisk-gz*)<Plug>Pulse
map g# <Plug>(asterisk-gz#)<Plug>Pulse
cmap <silent> <expr> <enter> search_pulse#PulseFirst()
