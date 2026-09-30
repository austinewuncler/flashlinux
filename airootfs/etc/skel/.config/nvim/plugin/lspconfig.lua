vim.pack.add({ "https://github.com/neovim/nvim-lspconfig.git" })

local diagnostic_signs = require("zoom.utils").diagnostic_signs

vim.diagnostic.config({
	float = { focus = false, severity_sort = true, source = true },
	jump = {
		on_jump = function()
			vim.diagnostic.open_float()
		end,
	},
	severity_sort = true,
	signs = { text = diagnostic_signs },
	update_in_insert = true,
	virtual_text = {
		prefix = function(diagnostic)
			return diagnostic_signs[diagnostic.severity]
		end,
		source = true,
	},
})
