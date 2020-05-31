scriptencoding utf-8

let s:BORDERCHARS =  ['─', '│', '┌', '┐', '┘', '└']
let s:WATCH_INTERVAL = 100

function! loupe#window#open(expr, ...) abort
  let options = extend({
        \ 'line': 1,
        \ 'col': 1,
        \ 'border': 1,
        \ 'botright': 1,
        \ 'width_ratio': 0.4,
        \ 'height_ratio': 1,
        \ 'highlight': 'LoupeNormal',
        \ 'borderchars': s:BORDERCHARS,
        \ 'watch_interval': s:WATCH_INTERVAL,
        \}, a:0 ? a:1 : {},
        \)
  let window = s:open(a:expr, options)
  call s:watch(win_getid(), window.close, options.watch_interval)
  return window
endfunction

function! s:create_container_content(width, height, borderchars) abort
  let bs = a:borderchars
  let w = a:width
  let h = a:height
  let head = bs[2] . repeat(bs[0], w - 2) . bs[3]
  let body = bs[1] . repeat(' ', w - 2) . bs[1]
  let tail = bs[5] . repeat(bs[0], w - 2) . bs[4]
  let content = [head] + repeat([body], h - 2) + [tail]
  return content
endfunction

function! s:open(expr, options) abort
  let winid_saved = win_getid()
  let width = float2nr(winwidth(0) * a:options.width_ratio)
  let height = float2nr(winheight(0) * a:options.height_ratio)
  if a:options.botright
    let anchor = 'SE'
    let col = winwidth(0)
    let row = winheight(0)
  else
    let anchor = 'NW'
    let col = 0
    let row = 0
  endif
  let winids = []

  if a:options.border
    let content = s:create_container_content(width, height, a:options.borderchars)
    let bufnr_container = nvim_create_buf(v:false, v:true)
    let winid_container = nvim_open_win(bufnr_container, v:false, {
          \ 'relative': 'win',
          \ 'win': winid_saved,
          \ 'width': width,
          \ 'height': height,
          \ 'col': col,
          \ 'row': row,
          \ 'anchor': anchor,
          \ 'style': 'minimal',
          \ 'focusable': v:false,
          \})
    call nvim_buf_set_lines(bufnr_container, 0, -1, 0, content)
    call nvim_win_set_option(
          \ winid_container,
          \ 'winhighlight',
          \ printf('Normal:%s', a:options.highlight),
          \)
    call add(winids, winid_container)
    let col += anchor ==# 'NW' ? 1 : -1
    let row += anchor ==# 'NW' ? 1 : -1
    let width = width - 2
    let height = height - 2
    redraw
  endif

  let bufnr = bufnr(a:expr)
  let bufnr = bufnr is# -1 ? nvim_create_buf(v:false, v:false) : bufnr
  let winid = nvim_open_win(bufnr, v:false, {
        \ 'relative': 'win',
        \ 'win': winid_saved,
        \ 'width': width,
        \ 'height': height,
        \ 'col': col,
        \ 'row': row,
        \ 'anchor': anchor,
        \ 'style': 'minimal',
        \ 'focusable': v:false,
        \})
  call nvim_win_set_option(
        \ winid,
        \ 'winhighlight',
        \ printf('Normal:%s', a:options.highlight),
        \)
  call add(winids, winid)
  call nvim_win_set_cursor(winid, [a:options.lnum, a:options.col])
  silent normal! z.
  setlocal cursorline
  call win_gotoid(winid_saved)
  return {
        \ 'winid': winid,
        \ 'close': { -> map(winids, { -> s:close(v:val) }) },
        \}
endfunction

function! s:close(winid) abort
  silent! call nvim_win_close(a:winid, v:true)
endfunction

function! s:watch(winid, fn, interval) abort
  if !nvim_win_is_valid(a:winid)
    call a:fn()
  else
    call timer_start(a:interval, { -> s:watch(a:winid, a:fn, a:interval) })
  endif
endfunction

function! loupe#viewer#nvim#open(bufnr, options) abort
  let width = a:options.width
  let height = a:options.height
  if a:options.botright
    let anchor = 'SE'
    let col = winwidth(0)
    let row = winheight(0)
  else
    let anchor = 'NW'
    let col = 0
    let row = 0
  endif
  let done = []

  if a:options.border
    let content = s:create_container_content(width, height, a:options.borderchars)
    let bufnr_container = nvim_create_buf(v:false, v:true)
    let winid_container = nvim_open_win(bufnr_container, v:false, {
          \ 'relative': 'win',
          \ 'width': width,
          \ 'height': height,
          \ 'col': col,
          \ 'row': row,
          \ 'anchor': anchor,
          \ 'style': 'minimal',
          \ 'focusable': v:false,
          \})
    call nvim_buf_set_lines(bufnr_container, 0, -1, 0, content)
    call nvim_win_set_option(
          \ winid_container,
          \ 'winhighlight',
          \ printf('Normal:%s', a:options.highlight),
          \)
    call add(winids, winid_container)
    let col += anchor ==# 'NW' ? 1 : -1
    let row += anchor ==# 'NW' ? 1 : -1
    let width = width - 2
    let height = height - 2
    redraw
  endif

  let bufnr = bufnr(a:expr)
  let bufnr = bufnr is# -1 ? nvim_create_buf(v:false, v:false) : bufnr
  let winid = nvim_open_win(bufnr, v:false, {
        \ 'relative': 'win',
        \ 'width': width,
        \ 'height': height,
        \ 'col': col,
        \ 'row': row,
        \ 'anchor': anchor,
        \ 'style': 'minimal',
        \ 'focusable': v:false,
        \})
  call nvim_win_set_option(
        \ winid,
        \ 'winhighlight',
        \ printf('Normal:%s', a:options.highlight),
        \)
  call add(winids, winid)
  call nvim_win_set_cursor(winid, [a:options.lnum, a:options.col])
  silent normal! z.
  setlocal cursorline
  call win_gotoid(winid_saved)
  return {
        \ 'winid': winid,
        \ 'close': { -> map(winids, { -> s:close(v:val) }) },
        \}
endfunction

function! loupe#viewer#nvim#close(window) abort
endfunction

function! loupe#viewer#nvim#execute(window, command, ...) abort
endfunction

function! s:win_execute(id, command, ...) abort
  let silent = a:0 ? a:1 : 'silent'
  let winid_saved = win_getid()
  try
    noautocmd call win_gotoid(a:id)
    return execute(a:command, silent)
  finally
    noautocmd call win_gotoid(winid_saved)
  endtry
endfunction
