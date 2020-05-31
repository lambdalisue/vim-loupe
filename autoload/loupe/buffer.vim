function! loupe#buffer#BufReadCmd() abort
  let bufname = matchstr(expand('<afile>'), '^loupe://\zs.*')
  let content = s:read(bufname)
  call setline(1, content)
  filetype detect
  setlocal buftype=nofile
  setlocal bufhidden=wipe
  setlocal nomodifiable noswapfile nobuflisted
endfunction

function! s:read(bufname) abort
  if bufexists(a:bufname)
    return getbufline(a:bufname, 1, '$')
  elseif filereadable(a:bufname)
    return readfile(a:bufname)
  endif
  throw printf("[loupe] failed to read %s", a:bufname)
endfunction
