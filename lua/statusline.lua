local hasNvim = vim.api and true

local cmd, eval, isActive, winnr, setwinvar, getwinvar
if hasNvim then
	cmd = vim.api.nvim_command
	eval = vim.api.nvim_eval
	winnr = function(n) 
		local str = "winnr(\"" .. (n and tostring(n) or "") .. "\")"
		return eval(str)
	end
	setwinvar = function(windowNumber, varName, value)
		local windowId = eval("win_getid("..tostring(windowNumber)..")")
		return eval(string.format(
			"setwinvar(%d, \"%s\", \"%s\")",
			windowId, varName, tostring(value)
		))
		--return vim.api.nvim_win_set_var(tostring(windowId), varName, value)
	end
	getwinvar = function(windowNumber, varName)
		local windowId = eval("win_getid("..tostring(windowNumber)..")")
		return eval(string.format(
			"getwinvar(%d, \"%s\")",
			windowId, varName
		))
	end
else
	cmd = vim.command
	eval = vim.eval
	winnr = vim.funcref("winnr")
	setwinvar = vim.funcref("setwinvar")
	getwinvar = vim.funcref("getwinvar")
end

local function setup(t, key, tab)
	cmd(string.format(
	"hi StatusLineColor%s ctermfg=%d ctermbg=%d guifg=#%06x guibg=#%06x",
	tab[1]:gsub(" ",""), tab[2], tab[3], tab[4], tab[5]
	))
	rawset(t, key, {
		modeKey = tab[key],
		modeName = tab[1],
		hiGroup = "%#StatusLineColor" .. tab[1]:gsub(" ","") .. "#",
	})
end
local modes = setmetatable({}, {
	__index = function() 
		return {
			modeName="??????",
			hiGroup = "%#Error#"
		}
	end,
	__newindex = setup
})
modes["n"] = {"Normal", 25, 87, 0x005FAF, 0x5FFFFF}
modes["i"] = {"Insert", 28, 10, 0x008700, 0x00FF00}
modes["R"] = {"Replace", 124, 204, 0xAF0000, 0xff5f87}
modes["v"] = {"Visual", 58, 221, 0x5F5F00, 0xFFD75F}
modes["V"] = {"Visual Line", 58, 221, 0x5F5F00, 0xFFD75F}
modes[""] = {"Visual Block", 58, 221, 0x5F5F00, 0xFFD75F}
modes["c"] = {"Command", 53, 134, 0x5F005F, 0xAF5Fd7}
modes["t"] = {"Terminal", 0, 185, 0x000000, 0xD7D75F}

local function mode()
	return modes[eval("mode()")]
end
local fmt = table.concat{
	"%%{UpdateStatusline()}",
	"%s %s ", -- Highlighed mode name
	"%%#BufferNumber# %%n ", -- buffer number
	"%%#FileName# %%.30f %%y%%r%%h%%w%%m ", -- filename, extension, modification flag
	"%s", -- highlighted bar to show active window
	"%%=", -- fill
	"%%#LineNumber# %%l/%%L:%%c %%3p%%%%  ", -- line number, columns, percent through file
}
local function activeLine()
	local data = mode()
	local modeHighlight = data.hiGroup
	local modeStr = data.modeName
	local lineHighlight = "%#ActiveLine#"
	return fmt:format(modeHighlight, modeStr, lineHighlight)
end
local function nonactiveLine()
	local modeHighlight = "%#NonActiveLine#"
	local modeStr = "      "
	local lineHighlight = "%#NonActiveLine#"
	return fmt:format(modeHighlight, modeStr, lineHighlight)
end
local function get(bool)
	if bool then
		return activeLine()
	end
	return nonactiveLine()
end
local function update()
	local n = winnr("$")
	if not n then
		return
	end
	for i = 1, n do
		-- vim complains about lua 5.1 not having ints,
		-- but is fine with strings
		local active = getwinvar(tostring(i), "active") == "true"
		setwinvar(tostring(i), "&statusline", get(active))
	end
end
return {
	update = update
}
