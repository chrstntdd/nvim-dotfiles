local themes = {
  "catppuccin-frappe",
  "catppuccin-macchiato",
  "catppuccin-mocha",
}

local function selectRandomTheme(themeList)
  math.randomseed(os.time())
  local index = math.random(#themeList)
  return themeList[index]
end

return {
  {

    "catppuccin/nvim",
    priority = 1000,
    config = function()
      -- Assign random theme
      vim.cmd("colorscheme " .. selectRandomTheme(themes))
      vim.cmd("hi comment gui=none")
    end,
  },
}
