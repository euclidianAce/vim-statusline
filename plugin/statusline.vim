if !has("lua") && !has("nvim")
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

if !has("nvim")
	let s:plugin_path = escape(expand("<sfile>:p:h:h"), "\\")
	lua package.path = vim.eval("s:plugin_path") .. "/lua/?.lua;"
				\ .. package.path
endif
function! UpdateStatusline()
	lua require("statusline").update()
	return ""
endfunction

augroup customstatusline
	autocmd CmdlineEnter * redrawstatus
	autocmd WinEnter * :call setwinvar(winnr(), "active", "true")
	autocmd WinLeave * :call setwinvar(winnr(), "active", "false")
	autocmd VimEnter * :call setwinvar(winnr(), "active", "true")
	autocmd * :call UpdateStatusline()
augroup END
set statusline=%!UpdateStatusline()

let &cpo = s:save_cpo
unlet s:save_cpo
let g:loaded_statusline = 1
