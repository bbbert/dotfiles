" Get the git root of the cwd
function! GetGitRoot()
  let root = split(system('git rev-parse --show-toplevel'), '\n')[0]
  return v:shell_error ? '' : root
endfunction

" Get the active buffer's git root or fall back to its parent directory
function! GetBufferGitRoot(fallback_to_parent)
  let buf_parent_dir = expand('%:p:h')
  let buf_git_root = split(system('cd ' . buf_parent_dir . '; git rev-parse --show-toplevel'), '\n')[0]
  if a:fallback_to_parent
    return v:shell_error ? buf_parent_dir : buf_git_root
  else
    return v:shell_error ? '' : buf_git_root
  endif
endfunction

" Dispatch to fzf commands.
"
" code = p|g|m|f
"   p = filename search
"   g = filename search among git files
"   m = filename search among modified (including untracked) files in git
"   f = full text search
"
" use_current_word = initially search for the current word under the cursor
"
" use_buffer_dir = for p and f, use the current buffer's git repo root or
"                  fallback to its parent dir, instead of the cwd
" use_buffer_dir = for g and m, use the current buffer's git repo root
"                  instead of the cwd's git repo root
function! FZFCommand(code, use_current_word, use_buffer_dir)
  let maybe_query_cword = a:use_current_word 
    \ ? ' -i --query ' . expand('<cword>') : ''

  if a:code == 'p'
    let search_dir = a:use_buffer_dir ? GetBufferGitRoot(1) : ''
    let fzf_opts = fzf#vim#with_preview({ 'options': maybe_query_cword })
    call fzf#vim#files(search_dir, fzf_opts, 0)

  elseif a:code == 'g' || a:code == 'm'
    let root = a:use_buffer_dir ? GetBufferGitRoot(0) : GetGitRoot()
    if empty(root)
      echoerr (a:use_buffer_dir ? 'buffer ' : 'cwd ') . 'is not in a git repo.'
      return
    endif

    let is_win = has('win32') || has('win64')

    if a:code == 'g'
      " duplicate of the fzf ls-files command
      let fzf_opts = fzf#vim#with_preview({
        \ 'source':  'git ls-files' . (is_win ? '' : ' | uniq'),
        \ 'dir':     root,
        \ 'options': '-m --prompt "GitFiles> "' . maybe_query_cword,
        \ })
      return fzf#run(fzf#wrap('gfiles', fzf_opts, 0))

    elseif a:code == 'm'
      " duplicate of the fzf git status command

      " Here be dragons!
      " We're trying to access the common sink function that fzf#wrap injects to
      " the options dictionary.
      let preview = printf(
        \ 'bash -c "if [[ {1} =~ M ]]; then %s; else head -n128 {-1}; fi"',
        \ 'git diff --color=always -- {-1} | sed 1,4d')
      let wrapped = fzf#wrap({
        \ 'source':  'git -c color.status=always status --short --untracked-files=all',
        \ 'dir':     root,
        \ 'options': [ '--ansi', '--multi', '--nth', '2..,..', '--tiebreak=index',
        \              '--prompt', 'GitFiles?> ', '--preview', preview ] })
      for key in ['window', 'up', 'down', 'left', 'right']
        if has_key(wrapped, key)
          call remove(wrapped, key)
        endif
      endfor
      let wrapped.common_sink = remove(wrapped, 'sink*')
      function! wrapped.newsink(lines)
        let lines = extend(a:lines[0:0], map(a:lines[1:], 'substitute(v:val[3:], ".* -> ", "", "")'))
        return self.common_sink(lines)
      endfunction
      let wrapped['sink*'] = remove(wrapped, 'newsink')
      return fzf#run(fzf#wrap('gfiles-diff', wrapped, 0))
    endif

  elseif a:code == 'f'
    let search_dir = a:use_buffer_dir ? GetBufferGitRoot(1) : ''
    let search_term = a:use_current_word ? expand('<cword>') : ''
    let grep_cmd = 'rg --column --line-number --no-heading --color=always'
      \ . ' --smart-case ' . shellescape(search_term)
    call fzf#vim#grep(grep_cmd, 1, 
      \ fzf#vim#with_preview({
      \   'options': '--delimiter : --nth 4..',
      \   'dir': search_dir
      \ }), 0)
  endif
endfunction
command! -nargs=* FZFCommand call FZFCommand(<f-args>)

" Switch to other split before executing command if inside the NERD tree.
function! OutsideNERD(cmd)
  return (expand('%') =~ 'NERD_tree' ? "\<C-W>\<C-W>" : '') . a:cmd
endfunction

" Mapping format: <cmd>[l][(w|<cmd>)]
"
" <cmd> is repeated: perform the command without a pre-filled search
" just <cmd>: wait for timeoutlen, then perform the command
" w: use current word under cursor as initial search
" l: buffer local; use buffer to find root dir or root repo dir
" no l: workspace local; use buffer to find root dir or root repo dir
"
" <cmd> = p : perform ctrl-P style filename search
" <cmd> = g : filename search among git-tracked files only
" <cmd> = m : filename search among all modified or untracked git files
" <cmd> = f : full text search

" Search filenames
nnoremap <expr> <Leader>p OutsideNERD(':FZFCommand p 0 0<CR>')
nnoremap <expr> <Leader>pp OutsideNERD(':FZFCommand p 0 0<CR>')
nnoremap <expr> <Leader>pw OutsideNERD(':FZFCommand p 1 0<CR>')
nnoremap <expr> <Leader>pl OutsideNERD(':FZFCommand p 0 1<CR>')
nnoremap <expr> <Leader>plp OutsideNERD(':FZFCommand p 0 1<CR>')
nnoremap <expr> <Leader>plw OutsideNERD(':FZFCommand p 1 1<CR>')

" Search git-tracked filenames
nnoremap <expr> <Leader>g OutsideNERD(':FZFCommand g 0 0<CR>')
nnoremap <expr> <Leader>gg OutsideNERD(':FZFCommand g 0 0<CR>')
nnoremap <expr> <Leader>gw OutsideNERD(':FZFCommand g 1 0<CR>')
nnoremap <expr> <Leader>gl OutsideNERD(':FZFCommand g 0 1<CR>')
nnoremap <expr> <Leader>glg OutsideNERD(':FZFCommand g 0 1<CR>')
nnoremap <expr> <Leader>glw OutsideNERD(':FZFCommand g 1 1<CR>')

" Search modified filenames in a git repo, whether tracked or not
nnoremap <expr> <Leader>m OutsideNERD(':FZFCommand m 0 0<CR>')
nnoremap <expr> <Leader>mm OutsideNERD(':FZFCommand m 0 0<CR>')
nnoremap <expr> <Leader>mw OutsideNERD(':FZFCommand m 1 0<CR>')
nnoremap <expr> <Leader>ml OutsideNERD(':FZFCommand m 0 1<CR>')
nnoremap <expr> <Leader>mlm OutsideNERD(':FZFCommand m 0 1<CR>')
nnoremap <expr> <Leader>mlw OutsideNERD(':FZFCommand m 1 1<CR>')

" Full text search
nnoremap <expr> <Leader>f OutsideNERD(':FZFCommand f 0 0<CR>')
nnoremap <expr> <Leader>ff OutsideNERD(':FZFCommand f 0 0<CR>')
nnoremap <expr> <Leader>fw OutsideNERD(':FZFCommand f 1 0<CR>')
nnoremap <expr> <Leader>fl OutsideNERD(':FZFCommand f 0 1<CR>')
nnoremap <expr> <Leader>flf OutsideNERD(':FZFCommand f 0 1<CR>')
nnoremap <expr> <Leader>flw OutsideNERD(':FZFCommand f 1 1<CR>')

" Search among the currently open buffers
nnoremap <expr> <Leader>b OutsideNERD(":Buffers<CR>")
