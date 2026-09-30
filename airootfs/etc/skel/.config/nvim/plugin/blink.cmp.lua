vim.pack.add({
	"https://github.com/saghen/blink.lib.git",
	"https://github.com/rafamadriz/friendly-snippets.git",
	"https://github.com/xzbdmw/colorful-menu.nvim.git",
	"https://github.com/timrydefalk/blink-cmp-nerdfont.git",
	"https://github.com/saghen/blink.cmp.git",
})

local blink_cmp = require("blink.cmp")

blink_cmp.build():pwait()

local mini_icons_get = require("mini.icons").get
local colorful_menu = require("colorful-menu")

local function get_mini_icon(ctx)
	if ctx.source_name == "Path" then
		local is_unknown_type =
			vim.tbl_contains({ "link", "socket", "fifo", "char", "block", "unknown" }, ctx.item.data.type)
		local mini_icon, mini_hl =
			mini_icons_get(is_unknown_type and "os" or ctx.item.data.type, is_unknown_type and "" or ctx.label)

		if mini_icon then
			return mini_icon, mini_hl
		end
	end

	local mini_icon, mini_hl, _ = mini_icons_get("lsp", ctx.kind)

	return mini_icon, mini_hl
end

blink_cmp.setup({
	completion = {
		documentation = { auto_show = true },
		keyword = { range = "prefix" },
		list = { selection = { auto_insert = false } },
		menu = {
			draw = {
				columns = { { "kind_icon" }, { "label", gap = 1 } },
				components = {
					kind = {
						highlight = function(ctx)
							local _, hl = get_mini_icon(ctx)

							return hl
						end,
					},
					kind_icon = {
						highlight = function(ctx)
							local _, hl = get_mini_icon(ctx)

							return hl
						end,
						text = function(ctx)
							local kind_icon = get_mini_icon(ctx)

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
			lsp = {
				module = "blink.cmp.sources.lsp",
				name = "LSP",
				transform_items = function(_, items)
					return vim.tbl_filter(function(item)
						return item.kind ~= require("blink.cmp.types").CompletionItemKind.Keyword
					end, items)
				end,
			},
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
