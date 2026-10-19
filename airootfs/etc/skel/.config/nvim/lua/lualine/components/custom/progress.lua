return function()
  local current = vim.fn.line(".")
  local total = vim.fn.line("$")

  if current == 1 then
    return "󰄰 "
  elseif current == total then
    return "󰪥 "
  else
    local slices = { "󰪞 ", "󰪟 ", "󰪠 ", "󰪡 ", "󰪢 ", "󰪣 ", "󰪤 " }

    return slices[math.ceil((current / total) * #slices)]
  end
end
