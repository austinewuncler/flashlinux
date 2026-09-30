vim.pack.add({ { src = "https://github.com/catppuccin/nvim.git", name = "catppuccin" } })

require("catppuccin").setup({
	float = { solid = false, transparent = true },
	integrations = { mason = true, noice = true },
	lsp_styles = {
		underlines = {
			errors = { "undercurl" },
			hints = { "undercurl" },
			information = { "undercurl" },
			ok = { "undercurl" },
			warnings = { "undercurl" },
		},
	},
	styles = {
		booleans = { "bold" },
		functions = { "italic" },
		keywords = { "bold" },
		loops = { "italic" },
		numbers = { "bold" },
		operators = { "bold" },
	},
	term_colors = true,
	transparent_background = true,
})

vim.cmd.colorscheme("catppuccin-nvim")
