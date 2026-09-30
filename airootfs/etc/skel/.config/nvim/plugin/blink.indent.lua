vim.pack.add({ "https://github.com/saghen/blink.indent.git" })

require("blink.indent").setup({
	scope = {
		highlights = {
			"BlinkIndentRed",
			"BlinkIndentYellow",
			"BlinkIndentBlue",
			"BlinkIndentOrange",
			"BlinkIndentGreen",
			"BlinkIndentViolet",
			"BlinkIndentCyan",
		},
	},
	static = { char = "▏" },
})
