function! loupe#start(...) abort
  let b:loupe_lens = loupe#lens#{&filetype}#new(win_getid())
  let b:loupe_window = v:null

  augroup loupe_start
    autocmd! * <buffer>
    autocmd CursorMoved <buffer> call s:CursorMoved()
  augroup END

  call s:apply()
endfunction

function! s:CursorMoved() abort
  call s:apply()
endfunction

function! s:apply() abort
  let lnum = line('.')
  let lens = b:loupe_lens
  let previous = b:loupe_window

  if previous isnot# v:null
    call previous.close()
  endif

  let image = lens.refract(lnum)
  let window = loupe#window#open(image.expr, {
        \ 'lnum': image.lnum,
        \ 'col': image.col,
        \})

  let b:loupe_window = window
endfunction
