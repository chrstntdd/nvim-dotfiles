function ApplyColors(color)
  color = color or "noctis"
  vim.cmd.colorscheme = color
end

ApplyColors()