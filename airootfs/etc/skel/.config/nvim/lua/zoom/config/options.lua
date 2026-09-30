for key, value in pairs({
	loaded_node_provider = 0,
	loaded_perl_provider = 0,
	loaded_python3_provider = 0,
	loaded_ruby_provider = 0,
	mapleader = " ",
}) do
	vim.g[key] = value
end

for key, value in pairs({
	breakindent = true,
	conceallevel = 3,
	confirm = true,
	cursorline = true,
	cursorlineopt = "number",
	expandtab = true,
	fillchars = "eob: ",
	ignorecase = true,
	linebreak = true,
	mouse = "",
	number = true,
	relativenumber = true,
	scrolloff = 999,
	shiftwidth = 2,
	showbreak = "󱞩 ",
	signcolumn = "yes",
	smartcase = true,
	smartindent = true,
	smoothscroll = true,
	splitbelow = true,
	splitright = true,
	startofline = true,
	tabstop = 2,
	undofile = true,
	winborder = "rounded",
}) do
	vim.o[key] = value
end
