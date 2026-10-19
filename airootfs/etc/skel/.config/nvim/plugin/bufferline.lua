vim.pack.add({ "https://github.com/akinsho/bufferline.nvim.git" })

local severity = vim.diagnostic.severity
local signs = require("zoom.shared").diagnostic_signs

require("bufferline").setup({
	highlights = require("catppuccin.special.bufferline").get_theme(),
	options = {
		always_show_bufferline = false,
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, _, _)
			local icon = level:match("error") and signs[severity.ERROR]
				or level:match("hint") and signs[severity.HINT]
				or level:match("info") and signs[severity.INFO]
				or level:match("warn") and signs[severity.WARN]
				or ""

			return " " .. icon .. count
		end,
		left_trunc_marker = "󰳝 ",
		right_trunc_marker = "󰳟 ",
		show_buffer_close_icons = false,
	},
})
