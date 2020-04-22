
function! ModeColor(mode)
	if a:mode == 'n'
		hi StatusLineColor ctermfg=25 ctermbg=87 guibg=#80a1d4 guifg=#000000
	elseif a:mode == 'i'
		hi StatusLineColor ctermfg=28 ctermbg=10 guibg=#36d495 guifg=#000000
	elseif a:mode == 'R'
		hi StatusLineColor ctermfg=124 ctermbg=204 guibg=#dd403a guifg=#000000
	elseif a:mode == 'v' || a:mode == 'V' || a:mode == ''
		hi StatusLineColor ctermfg=58 ctermbg=221 guibg=#f5cb5c guifg=#000000
	elseif a:mode == 'c'
		hi StatusLineColor ctermfg=53 ctermbg=134 guibg=#3f3f3f guifg=#000000
	elseif a:mode == 't'
		hi StatusLineColor ctermfg=0 ctermbg=185 guibg=#3f3f3f guifg=#000000
	endif
	return ''
endfunction
let g:currMode = {
	\ 'n': 'Normal',
	\ 'i': 'Insert',
	\ 'R': 'Replace',
	\ 'v': 'Visual',
	\ 'V': 'Visual Line',
	\ '': 'Visual Block',
	\ 'c': 'Command',
	\ 't': 'Terminal',
	\ }
hi LineNumber ctermfg=255 ctermbg=234 guibg=#101010 guifg=#9F9F9F
hi BufferNumber ctermfg=255 ctermbg=235 guibg=#202020
hi FileName ctermfg=255 ctermbg=236 guibg=#303030
hi ActiveLine ctermfg=255 ctermbg=238
hi NonActiveLine ctermfg=255 ctermbg=235
function! GetStatusline()
	let s = '%#FileName#'
	let active = g:statusline_winid == win_getid(winnr())
	if active
		let s .= '%{ModeColor(mode())}%#StatusLineColor# %{currMode[mode()]} '
	else
		let s .= '        '
	endif
	let s .= '%#BufferNumber# %n '
	let s .= '%#FileName# %f %y%r%h%w%m '
	if active
		let s .= '%#ActiveLine#'
	else
		let s .= '%#NonActiveLine#'
	end
	let s .= '%='
	let s .= '%#LineNumber# %l/%L:%c %3p%%  '

	return s
endfunction
set statusline=%!GetStatusline()
augroup customstatusline
	autocmd CmdlineEnter * redrawstatus
augroup END
