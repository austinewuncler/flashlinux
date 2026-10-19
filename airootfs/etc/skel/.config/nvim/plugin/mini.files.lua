vim.pack.add({ "https://github.com/nvim-mini/mini.files.git" })

local files = require("mini.files")

files.setup({ mappings = { close = "-", go_in_plus = "l" } })

vim.keymap.set("n", "-", files.open)
