vim.pack.add({ { src = "https://github.com/saghen/blink.pairs.git", version = vim.version.range("*") } })

local blink_pairs = require("blink.pairs")

blink_pairs.download():pwait(60000)

blink_pairs.setup({
	highlights = {
		groups = {
			"BlinkIndentRed",
			"BlinkIndentYellow",
			"BlinkIndentBlue",
			"BlinkIndentOrange",
			"BlinkIndentGreen",
			"BlinkIndentPurple",
			"BlinkIndentCyan",
		},
	},
})
