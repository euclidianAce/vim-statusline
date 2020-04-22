
local function setup(modeName, ctermfg, ctermbg)
	return {
		modeName = modeName,
		ctermfg = ctermfg,
		ctermbg = ctermbg,
	}
end
local modes = {
	["n"] = setup("Normal", 25, 87),
	["i"] = setup("Insert", 28, 10),
	["R"] = setup("Replace", 124, 204),
	["v"] = setup("Visual", 58, 221),
	["V"] = setup("Visual Line", 58, 221),
	[""] = setup("Visual Block", 58, 221),
	["c"] = setup("Command", 53, 134),
	["t"] = setup("Terminal", 0, 185),
}
local mode = vim.funcref("mode")
local tinsert = table.insert
local fmt = table.concat{
	"%%#FileName#",
	"%s %s ", -- Highlighed mode name
	"%%#BufferNumber# %%n",
	"%%#FileName# %%f %%y%%r%%h%%w%%m ",
	"%s", -- highlighted bar to show active window
	"%%=",
	"%%#LineNumber# %%l/%%L:%%c %%3p%%%%  ",
}
local function getStatusline()
	-- local currentBuffer = vim.buffer()
	-- local currentWindow = vim.window()
	-- local active = currentBuffer == currentWindow.buffer
	local active = vim.eval("g:statusline_winid") == vim.eval("win_getid(winnr())")
	local modeHighlight = "%#NonActiveLine#"
	local modeStr = "      "
	local lineHighlight = "%#NonActiveLine#"
	if active then
		local modeKey = mode()
		local m = modes[modeKey]
		vim.command(string.format(
			"hi StatusLineColor ctermfg=%d ctermbg=%d",
			m.ctermfg, m.ctermbg
		))
		modeHighlight = "%#StatusLineColor#"
		modeStr = m.modeName
		lineHighlight = "%#ActiveLine#"
	end
	return fmt:format(modeHighlight, modeStr, lineHighlight)
end
return getStatusline
