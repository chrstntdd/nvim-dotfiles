local themes = {
	"noctis_bordo",
	"noctis_uva",
	"noctis_minimus",
}

local function selectRandomTheme(themeList)
	math.randomseed(os.time())
	local index = math.random(#themeList)
	return themeList[index]
end

return {
	"talha-akram/noctis.nvim",
	priority = 1000,
	config = function()
		-- Assign random theme
		vim.cmd("colorscheme " .. selectRandomTheme(themes))
		vim.cmd("hi comment gui=none")
	end,
}
