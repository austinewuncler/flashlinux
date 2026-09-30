vim.pack.add({
	"https://github.com/folke/persistence.nvim.git",
	"https://github.com/MaximilianLloyd/ascii.nvim.git",
	"https://github.com/folke/snacks.nvim.git",
})

local persistence = require("persistence")

persistence.setup()

local snacks = require("snacks")

snacks.setup({
	bigfile = {},
	dashboard = {
		preset = {
			header = table.concat(require("ascii").art.text.neovim.sharp, "\n"),
			---@type snacks.dashboard.Item[]
			keys = {
				{ action = "<leader>ff", desc = "Find File", icon = "󰍉 ", key = "f" },
				{ action = "<leader>sg", desc = "Find Text", icon = "󰌌 ", key = "g" },
				{ action = "<leader>fr", desc = "Recent Files", icon = "󱋡 ", key = "r" },
				{ action = persistence.load, desc = "Restore Session", icon = "󰑐 ", key = "s" },
				{ action = "<cmd>qa<cr>", desc = "Quit", icon = "󰍃 ", key = "q" },
			},
		},
		sections = {
			{ section = "header" },
			{ icon = "󰌌 ", indent = 2, padding = 1, section = "keys", title = "Keymaps" },
			{ icon = "󱋡 ", indent = 2, padding = 1, section = "recent_files", title = "Recent Files" },
			{
				cmd = "git status --short --branch --renames",
				enabled = function()
					return snacks.git.get_root() ~= nil
				end,
				height = 5,
				icon = " ",
				indent = 3,
				padding = 1,
				pane = 2,
				section = "terminal",
				title = "Git Status",
				ttl = 5 * 60,
			},
		},
	},
	input = {},
	notifier = {},
	picker = {
		icons = { tree = { last = "╰╴" }, undo = { saved = "󰉉 " } },
		matcher = { cwd_bonus = true, frecency = true, history_bonus = true },
		prompt = " 󱃥  ",
	},
	quickfile = {},
	scope = {},
	scroll = {},
	statuscolumn = {},
	words = {},
})

local picker = snacks.picker
local bufdelete = snacks.bufdelete

require("which-key").add({
	{
		"<leader>b",
		group = "buffer",
		{ "<leader>bd", bufdelete.delete, desc = "delete" },
		{ "<leader>bD", bufdelete.all, desc = "delete all" },
		{ "<leader>bo", bufdelete.other, desc = "delete others" },
	},
	{
		"<leader>f",
		group = "find",
		{ "<leader>ff", picker.files, desc = "files" },
		{ "<leader>fr", picker.recent, desc = "recent files" },
	},
	{ "<leader>g", snacks.lazygit.open, desc = "git" },
	{ "<leader>s", group = "search", { "<leader>sg", picker.grep, desc = "grep" } },
})
