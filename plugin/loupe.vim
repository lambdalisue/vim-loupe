if exists('g:loupe_loaded')
  finish
endif
let g:loupe_loaded = 1

augroup loupe_internal
  autocmd! *
  autocmd ColorScheme * call s:set_highlights()
  autocmd BufReadCmd loupe://* ++nested call loupe#buffer#BufReadCmd()
augroup END

function! s:set_highlights() abort
  highlight default link LoupeNormal DiffDelete
endfunction

call s:set_highlights()
