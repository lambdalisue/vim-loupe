scriptencoding utf-8

function! loupe#internal#preview_window#nvim#open(bufname, options) abort
  let win = s:open(
        \ a:bufname,
        \ float2nr(winwidth(0) * 0.4),
        \ winheight(0),
        \)
  return win
endfunction


function! s:outer_window() abort
endfunction

function! s:open(bufname, w, h) abort
  let win_saved = win_getid()
  let head = '╭' . repeat('─', a:w - 2) . '╮'
  let body = '│' . repeat(' ', a:w - 2) . '│'
  let tail = '╰' . repeat('─', a:w - 2) . '╯'
  let options = {
        \ 'relative': 'win',
        \ 'win': win_saved,
        \ 'anchor': 'NW',
        \ 'width': a:w,
        \ 'height': a:h,
        \ 'col': winwidth(0) - a:w,
        \ 'row': float2nr((winheight(0) - a:h) / 2),
        \ 'style': 'minimal',
        \}
  let content = [head] + repeat([body], a:h - 2) + [tail]
  let buf_outer = nvim_create_buf(v:false, v:true)
  call nvim_buf_set_lines(buf_outer, 0, -1, v:true, content)
  let win_outer = nvim_open_win(buf_outer, v:true, extend(copy(options), {
       \ 'focusable': v:false,
       \}))
  call nvim_win_set_option(win_outer, 'winhighlight', 'Normal:Normal')

  let buf_inner = bufadd(a:bufname)
  let win_inner = nvim_open_win(buf_inner, v:true, extend(copy(options), {
        \ 'width': options.width - 2,
        \ 'col': options.col + 1,
        \ 'height': options.height - 2,
        \ 'row': options.row + 1,
        \}))
  call bufload(buf_inner)
  call nvim_win_set_option(win_inner, 'winhighlight', 'Normal:Normal')
  call nvim_win_set_option(win_inner, 'foldenable', v:false)
  call nvim_win_set_option(win_inner, 'cursorline', v:true)
  try
    noautocmd call win_gotoid(win_inner)
    augroup glanca_preview
      autocmd! * <buffer>
      autocmd BufWipeout <buffer> execute printf('%dbwipeout', b:glanca_outer_bufnr)
    augroup END
  finally
    noautocmd call win_gotoid(win_saved)
  endtry
  return win_inner
endfunction
