function! glanca#internal#viewer#start(winid, bufnr, lens) abort
  call setwinvar(a:winid, 'glanca_lens', a:lens)
  call setwinvar(a:winid, 'glanca_lens', a:lens)

  augroup glanca_internal_viewer
    autocmd! <buffer> *
    autocmd <buffer> CursorMoved,CursorMovedI call s:CursorMoved()
    autocmd <buffer> WinLeave ++once call s:WinLeave()
  augroup END

endfunction

function! s:CursorMoved() abort
  let line = line('.')
  if line is# w:glanca_previous_line
    return
  endif
  let lens = w:glanca_lens
  let r = lens.refrect(line)
  if r is# v:null
    return
  endif
  let w:glanca_previous_line = line
  let w:glanca_preview_close = glanca#internal#preview#open(r.bufname, {
        \ 'lnum': r.lnum,
        \ 'col': r.col,
        \})
endfunction

function! s:WinLeave() abort
endfunction
