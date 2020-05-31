function! loupe#lens#qf#new(winid) abort
  return {
        \ 'refract': funcref('s:refract', [getqflist()])
        \}
endfunction

function! s:refract(items, lnum) abort
  let item = get(a:items, a:lnum - 1, v:null)
  if item is# v:null
    return v:null
  endif
  return {
        \ 'expr': item.bufnr,
        \ 'lnum': item.lnum,
        \ 'col': item.col,
        \}
endfunction
