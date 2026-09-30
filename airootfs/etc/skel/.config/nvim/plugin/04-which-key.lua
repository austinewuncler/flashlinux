vim.pack.add({ "https://github.com/folke/which-key.nvim.git" })

require("which-key").setup({
  icons = {
    breadcrumb = "󰄾",
    keys = { BS = "󰌍", Down = "󰁅 ", Left = "󰁍 ", Right = "󰁔 ", Up = "󰁝 " },
    separator = "󱦰",
  },
  ---@type false | "classic" | "modern" | "helix"
  preset = "modern",
})
