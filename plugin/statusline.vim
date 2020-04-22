if !has("lua")
	echoerr "This plugin requires lua"
	finish
endif
if exists("g:loaded_statusline") | finish | endif
let s:save_cpo = &cpo
set cpo&vim

hi LineNumber ctermfg=255 ctermbg=234 guibg=#101010 guifg=#9F9F9F
hi BufferNumber ctermfg=255 ctermbg=235 guibg=#202020
hi FileName ctermfg=255 ctermbg=236 guibg=#303030
hi ActiveLine ctermfg=255 ctermbg=238
hi NonActiveLine ctermfg=255 ctermbg=235

let s:plugin_path = escape(expand("<sfile>:p:h"), "\\")
lua package.path = vim.eval("s:plugin_path") .. "/?.lua;"
	\ .. package.path
lua statusline = require("statusline")
function! GetStatusline()
	return luaeval("statusline()")
endfunction
set statusline=%!GetStatusline()

augroup customstatusline
	autocmd CmdlineEnter * redrawstatus
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
let g:loaded_statusline = 1
