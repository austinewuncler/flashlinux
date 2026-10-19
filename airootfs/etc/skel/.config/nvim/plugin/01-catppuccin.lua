vim.pack.add({ { src = "https://github.com/catppuccin/nvim.git", name = "catppuccin" } })

require("catppuccin").setup({
	integrations = { mason = true, noice = true },
	styles = {
		booleans = { "bold" },
		functions = { "italic" },
		keywords = { "bold" },
		loops = { "italic" },
		numbers = { "bold" },
		operators = { "bold" },
	},
	term_colors = true,
})

vim.cmd.colorscheme("catppuccin-nvim")
