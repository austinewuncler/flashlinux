vim.pack.add({ "https://github.com/nvim-mini/mini.files" })

local mini_files = require("mini.files")
mini_files.setup({ mappings = { close = "-", go_in_plus = "l" } })

vim.keymap.set("n", "-", mini_files.open)
