vim.pack.add({ "https://github.com/akinsho/bufferline.nvim.git" })

local diagnostic_severity = vim.diagnostic.severity
local diagnostic_signs = require("zoom.utils").diagnostic_signs

require("bufferline").setup({
	highlights = require("catppuccin.special.bufferline").get_theme(),
	options = {
		always_show_bufferline = false,
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, _, _)
			local icon = level:match("error") and diagnostic_signs[diagnostic_severity.ERROR]
				or level:match("hint") and diagnostic_signs[diagnostic_severity.HINT]
				or level:match("info") and diagnostic_signs[diagnostic_severity.INFO]
				or level:match("warn") and diagnostic_signs[diagnostic_severity.WARN]
				or ""

			return " " .. icon .. count
		end,
		left_trunc_marker = "󰳝 ",
		right_trunc_marker = "󰳟 ",
		show_buffer_close_icons = false,
	},
})
