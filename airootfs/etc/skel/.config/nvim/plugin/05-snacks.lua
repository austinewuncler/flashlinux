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
				{ action = "<leader>ff", desc = "Find File", icon = "󰈞 ", key = "f" },
				{ action = "<leader>sg", desc = "Find Text", icon = "󱎸 ", key = "g" },
				{ action = "<leader>fr", desc = "Recent Files", icon = "󱋡 ", key = "r" },
				{ action = "<leader>fc", desc = "Config", icon = "󱁻 ", key = "c" },
				{ action = persistence.load, desc = "Restore Session", icon = "󰑐 ", key = "s" },
				{ action = "<cmd>qa<cr>", desc = "Quit", icon = "󰍃 ", key = "q" },
			},
		},
		sections = {
			{ section = "header" },
			{ icon = "󰌌 ", indent = 2, padding = 1, section = "keys", title = "Keymaps" },
			{ icon = "󱋡 ", indent = 2, padding = 1, section = "recent_files", title = "Recent Files" },
		},
	},
	input = {},
	notifier = {},
	picker = {
		icons = {
			lsp = { disabled = "󰨙 ", enabled = "󰔡 " },
			tree = { last = "╰╴" },
			undo = { saved = "󰉉 " },
		},
		matcher = { cwd_bonus = true, frecency = true, history_bonus = true },
		prompt = " 󱃥  ",
	},
	quickfile = {},
	scope = {},
	scroll = {},
	statuscolumn = {},
	words = {},
})

local bufdelete = snacks.bufdelete
local picker = snacks.picker

require("which-key").add({
	{ "<c-/>", snacks.terminal.toggle, mode = { "n", "t" } },
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
		{
			"<leader>fc",
			function()
				picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "config files",
		},
		{ "<leader>ff", picker.files, desc = "files" },
		{ "<leader>fr", picker.recent, desc = "recent files" },
	},
	{ "<leader>s", group = "search", { "<leader>sg", picker.grep, desc = "grep" } },
})
