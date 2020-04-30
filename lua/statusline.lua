local hasNvim = vim.api and true

local cmd, eval, isActive, getMode
do
	if hasNvim then
		cmd = vim.api.nvim_command
		eval = vim.api.nvim_eval
		isActive = function()
			return true
		end
	else
		cmd = vim.command
		eval = vim.eval
		isActive = function(n)
			return eval("g:statusline_winid") == eval("win_getid(winnr())")
		end
	end
end

local function setup(t, key, tab)
	cmd(string.format(
	"hi StatusLineColor%s ctermfg=%d ctermbg=%d",
	tab[1]:gsub(" ",""), tab[2], tab[3]
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
modes["n"] = {"Normal", 25, 87}
modes["i"] = {"Insert", 28, 10}
modes["R"] = {"Replace", 124, 204}
modes["v"] = {"Visual", 58, 221}
modes["V"] = {"Visual Line", 58, 221}
modes[""] = {"Visual Block", 58, 221}
modes["c"] = {"Command", 53, 134}
modes["t"] = {"Terminal", 0, 185}

local function mode()
	return modes[eval("mode()")]
end
local fmt = table.concat{
	"%s %s ", -- Highlighed mode name
	"%%#BufferNumber# %%n ", -- buffer number
	"%%#FileName# %%f %%y%%r%%h%%w%%m ", -- filename, extension, modification flag
	"%s", -- highlighted bar to show active window
	"%%=", -- fill
	"%%#LineNumber# %%l/%%L:%%c %%3p%%%%  ", -- line number, columns, percent through file
}
local function getStatusline()
	local active = isActive()
	local modeHighlight = "%#NonActiveLine#"
	local modeStr = "      "
	local lineHighlight = "%#NonActiveLine#"
	if active then
		local data = mode()
		modeHighlight = data.hiGroup
		modeStr = data.modeName
		lineHighlight = "%#ActiveLine#"
	end
	return fmt:format(modeHighlight, modeStr, lineHighlight)
end
return {getStatusline=getStatusline}
