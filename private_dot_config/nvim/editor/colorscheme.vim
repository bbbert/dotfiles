try
  colorscheme OceanicNext
  let g:airline_theme = 'oceanicnext'
  set background=dark
catch /E185:/ "Cannot find color scheme
  colorscheme desert
endtry
