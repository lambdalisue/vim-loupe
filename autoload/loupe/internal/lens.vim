function! loupe#internal#lens#get(winid, filetype) abort
  try
    return loupe#lens#{a:filetype}#new(a:winid)
  catch /^Vim\%((\a\+)\)\=:E117: [^:]\+: loupe#lens#[^#]\+#.*/
    return v:null
  endtry
endfunction

