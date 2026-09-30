vim.pack.add({ "https://github.com/nvim-lualine/lualine.nvim" })

local palette = require("catppuccin.palettes").get_palette("mocha")
local mini_icons_get = require("mini.icons").get
local get_color_from_hl = require("snacks").util.color

require("lualine").setup({
	options = { component_separators = "", globalstatus = true, section_separators = "" },
	sections = {
		lualine_a = {},
		lualine_b = { { "filetype", icon_only = true, padding = 0, separator = { left = "" } } },
		lualine_c = {
			{
				"filename",
				color = function()
					local _, hl = mini_icons_get("file", vim.fn.expand("%:t"))

					return { bg = get_color_from_hl(hl), fg = palette.surface0, gui = "bold" }
				end,
				newfile_status = true,
				padding = 0,
				path = 1,
				separator = { left = "", right = "" },
				symbols = { modified = "󱇧 ", newfile = "󰝒 ", readonly = "󰈡 ", unnamed = "󰡯 " },
			},
			{
				function()
					return " "
				end,
				draw_empty = true,
				padding = 0,
			},
			{
				"b:gitsigns_head",
				color = { bg = palette.surface1, fg = palette.text, gui = "bold" },
				icon = "󰘬",
				padding = 0,
				separator = { left = "", right = "" },
			},
			{
				"diff",
				color = { bg = palette.surface0 },
				padding = { left = 1 },
				separator = { right = "" },
				source = function()
					local gitsigns = vim.b.gitsigns_status_dict

					if gitsigns then
						return { added = gitsigns.added, modified = gitsigns.changed, removed = gitsigns.removed }
					end
				end,
			},
		},
		lualine_x = {},
		lualine_y = {},
		lualine_z = {
			{
				"lsp_status",
				color = function()
					local _, hl = mini_icons_get("filetype", vim.bo.filetype)

					return { bg = get_color_from_hl(hl), fg = palette.base, gui = "bold" }
				end,
				icon = "",
				padding = 0,
				separator = { left = "", right = "" },
				symbols = { done = "", separator = "|" },
			},
		},
	},
})
