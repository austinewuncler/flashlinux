vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim.git" })

local get_mini_icon = require("mini.icons").get
local get_color_from_hl = require("snacks").util.color
local severity = vim.diagnostic.severity
local signs = require("zoom.shared").diagnostic_signs

require("lualine").setup({
	options = {
		component_separators = "",
		disabled_filetypes = { statusline = { "snacks_dashboard" } },
		globalstatus = true,
		section_separators = "",
	},
	sections = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = {
			{ "filetype", icon_only = true, padding = 0 },
			{
				"filename",
				color = function()
					local _, hl = get_mini_icon("file", vim.fn.expand("%:t"))

					return { fg = get_color_from_hl(hl), gui = "bold" }
				end,
				newfile_status = true,
				padding = { right = 1 },
				path = 1,
				symbols = { modified = "󱇧", newfile = "󰝒", readonly = "󰈡", unnamed = "󰡯" },
			},
		},
		lualine_x = {
			{
				"diagnostics",
				symbols = {
					error = signs[severity.ERROR],
					hint = signs[severity.HINT],
					info = signs[severity.INFO],
					signs[severity.WARN],
				},
				update_in_insert = true,
			},
			{ "custom.tools", padding = { left = 1 } },
			{
				"lsp_status",
				color = function()
					local _, hl = get_mini_icon("filetype", vim.bo.filetype)

					return { fg = get_color_from_hl(hl), gui = "bold" }
				end,
				icon = "",
				padding = { right = 1 },
				symbols = { done = "", separator = "|" },
			},
		},
		lualine_y = {
			{ "location", color = { bg = "none", gui = "bold" } },
			{ "custom.progress", color = { bg = "none" }, padding = 0 },
		},
		lualine_z = {},
	},
})
