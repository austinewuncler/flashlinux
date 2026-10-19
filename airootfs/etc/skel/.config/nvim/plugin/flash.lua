vim.pack.add({ "https://github.com/folke/flash.nvim.git" })

local flash = require("flash")

flash.setup()

vim.keymap.set({ "n", "x", "o" }, "s", flash.jump)
