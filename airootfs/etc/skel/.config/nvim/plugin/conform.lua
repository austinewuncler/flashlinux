vim.pack.add({ "https://github.com/stevearc/conform.nvim.git" })

require("conform").setup({ format_on_save = {}, formatters_by_ft = { sh = { "shellharden", "shfmt" } } })
