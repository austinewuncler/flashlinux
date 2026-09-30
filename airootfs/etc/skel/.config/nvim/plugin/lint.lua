vim.pack.add({ "https://github.com/mfussenegger/nvim-lint.git" })

local lint = require("lint")

lint.linters_by_ft = { sh = { "shellcheck" } }

vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
	callback = function()
		lint.try_lint()
	end,
})
