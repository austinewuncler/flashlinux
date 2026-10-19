vim.pack.add({ "https://github.com/neovim/nvim-lspconfig.git" })

local signs = require("zoom.shared").diagnostic_signs

vim.diagnostic.config({
	float = { focus = false, scope = "cursor", severity_sort = true, source = true },
	jump = {
		on_jump = function()
			vim.diagnostic.open_float()
		end,
	},
	severity_sort = true,
	signs = { text = signs },
	update_in_insert = true,
	virtual_text = {
		prefix = function(diagnostic)
			return signs[diagnostic.severity]
		end,
		source = true,
	},
})
