function! loupe#internal#closer#watch(winid, ...) abort
  let options = extend({
        \ 'parent_winid': win_getid(),
        \ 'interval': 100,
        \}, a:0 ? a:1 : {},
        \)
  call s:watch(options.interval, options.parent_winid, a:winid)
endfunction

if has('nvim')
  function! s:watch(interval, parent_winid, child_winid) abort
    if !nvim_win_is_valid(a:parent_winid)
      call nvim_win_close(a:child_winid, v:true)
      return
    endif
    call timer_start(
          \ a:interval,
          \ { -> s:watch(a:interval, a:parent_winid, a:child_winid) },
          \)
  endfunction
else
  function! s:watch(interval, parent_winid, child_winid) abort
    if win_id2tabwin(a:parent_winid) == [0, 0]
      call popup_close
      call win_execute(a:child_winid, 'close')
      return
    endif
    call timer_start(
          \ a:interval,
          \ { -> s:watch(a:interval, a:parent_winid, a:child_winid) },
          \)
  endfunction
endif
