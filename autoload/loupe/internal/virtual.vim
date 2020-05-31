function! loupe#internal#virtual#bufname(expr) abort
  return printf('loupe-virtual://%s', bufname(a:expr))
endfunction


function! s:BufReadCmd() abort
  let bufname = matchstr(bufname('<afile>'), '^loupe-virtual://\zs.*$')
  let content = bufexists(bufname)
        \ ? getbufline(bufname, 1, '$')
        \ : filereadable(bufname)
        \   ? readfile(bufname)
        \   : []
  call setline(1, content)
  filetype detect
endfunction

augroup loupe_internal_virtual
  autocmd! *
  autocmd BufReadCmd loupe-virtual://* ++nested call s:BufReadCmd()
augroup END
