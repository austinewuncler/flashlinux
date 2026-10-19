vim.pack.add({
	"https://github.com/saghen/blink.lib.git",
	"https://github.com/rafamadriz/friendly-snippets.git",
	"https://github.com/xzbdmw/colorful-menu.nvim.git",
	"https://github.com/timrydefalk/blink-cmp-nerdfont.git",
	"https://github.com/saghen/blink.cmp.git",
})

local cmp = require("blink.cmp")

cmp.build():pwait()

local get_mini_icon = require("mini.icons").get
local colorful_menu = require("colorful-menu")

local function get_icon(ctx)
	if ctx.source_name == "Path" then
		local is_unknown_type =
			vim.tbl_contains({ "link", "socket", "fifo", "char", "block", "unknown" }, ctx.item.data.type)
		local icon, hl =
			get_mini_icon(is_unknown_type and "os" or ctx.item.data.type, is_unknown_type and "" or ctx.label)

		if icon then
			return icon, hl
		end
	end
	local icon, hl = get_mini_icon("lsp", ctx.kind)

	return icon, hl
end

cmp.setup({
	completion = {
		documentation = { auto_show = true },
		keyword = { range = "full" },
		list = { selection = { auto_insert = false } },
		menu = {
			draw = {
				columns = { { "kind_icon" }, { "label", gap = 1 } },
				components = {
					kind = {
						highlight = function(ctx)
							local _, hl = get_icon(ctx)

							return hl
						end,
					},
					kind_icon = {
						highlight = function(ctx)
							local _, hl = get_icon(ctx)

							return hl
						end,
						text = function(ctx)
							local kind_icon = get_icon(ctx)

							return kind_icon
						end,
					},
					label = {
						highlight = function(ctx)
							return colorful_menu.blink_components_highlight(ctx)
						end,
						text = function(ctx)
							return colorful_menu.blink_components_text(ctx)
						end,
					},
				},
				treesitter = { "lsp" },
			},
		},
	},
	keymap = { preset = "enter" },
	signature = { enabled = true },
	sources = {
		default = { "lsp", "path", "snippets", "nerdfont" },
		providers = {
			nerdfont = {
				max_items = 10,
				min_keyword_length = 1,
				module = "blink-cmp-nerdfont",
				name = "blink-cmp-nerdfont",
				score_offset = 10,
			},
		},
	},
})
