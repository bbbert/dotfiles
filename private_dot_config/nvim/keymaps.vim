" Terminal
" --------

" Open a new terminal window
nmap <C-t> :below vnew<CR>:terminal<CR>i

" Exit terminal mode
tnoremap <Esc> <C-\><C-n>

" Close terminal window
tnoremap <C-w> <C-\><C-n><C-w>
tnoremap <C-q> <C-\><C-n>:bd!<CR>

" Popup menu navigation
" ---------------------

" Make it easier to browse the completion window
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

" Command shortcuts
" -----------------

" Make :W do the same thing as :w, and so on
cabbrev W w
cabbrev Wq wq
cabbrev WQ wq
cabbrev Q q
cabbrev Qa qa
cabbrev QA qa
cabbrev E e

" Yank over OSC 52
" ----------------

" copy to attached terminal using the yank(1) script:
" https://github.com/sunaku/home/blob/master/bin/yank
function! OscYank(text) abort
  let escape = system('yank', a:text)
  if v:shell_error
    echoerr escape
  else
    call writefile([escape], '/dev/tty', 'b')
  endif
endfunction

" automatically run yank(1) whenever yanking in Vim to the global register
" (this snippet was contributed by Larry Sanderson)
function! YankPostOscYank() abort
  if v:event.regname == "+"
    call OscYank(join(v:event.regcontents, "\n"))
  endif
endfunction
autocmd TextYankPost * call YankPostOscYank()
