vim.pack.add({ { src = "https://github.com/saghen/blink.pairs.git", version = vim.version.range("*") } })

local pairs = require("blink.pairs")

pairs.download():pwait(60000)

pairs.setup({
	highlights = {
		groups = {
			"BlinkPairsRed",
			"BlinkPairsYellow",
			"BlinkPairsBlue",
			"BlinkPairsOrange",
			"BlinkPairsGreen",
			"BlinkPairsPurple",
			"BlinkPairsCyan",
		},
	},
})
