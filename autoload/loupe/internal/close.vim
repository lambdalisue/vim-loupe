function! loupe#internal#close#watch(winid, callback, ...) abort
  let options = extend({
        \ 'interval': 100,
        \}, a:0 ? a:1 : {},
        \)
  call s:watch(options.interval, a:winid, a:callback)
endfunction

if has('nvim')
  function! s:watch(interval, winid, callback) abort
    if !nvim_win_is_valid(a:winid)
      call a:callback()
      return
    endif
    call timer_start(
          \ a:interval,
          \ { -> s:watch(a:interval, a:winid, a:callback) },
          \)
  endfunction
else
  function! s:watch(interval, winid, callback) abort
    if win_id2tabwin(a:winid) == [0, 0]
      call a:callback()
      return
    endif
    call timer_start(
          \ a:interval,
          \ { -> s:watch(a:interval, a:winid, a:callback) },
          \)
  endfunction
endif
