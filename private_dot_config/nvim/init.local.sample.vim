" Configure a python3 pyenv with neovim installed:
" pyenv install 3.9.0
" pyenv virtualenv 3.9.0 nvim-py3
" pyenv activate nvim-py3
" python3 -m pip install pynvim
let g:python3_host_prog = '$HOME/.pyenv/versions/3.9.0/envs/nvim-py3/bin/python'
