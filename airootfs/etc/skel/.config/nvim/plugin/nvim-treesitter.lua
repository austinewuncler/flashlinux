vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter.git" })

local NVIM_TREESITTER = "nvim-treesitter"

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local data = ev.data

		if data.spec.name == NVIM_TREESITTER and data.kind == "update" then
			if not data.active then
				vim.cmd.packadd(NVIM_TREESITTER)
			end

			vim.cmd("TSUpdate")
		end
	end,
})

local nvim_treesitter = require(NVIM_TREESITTER)

local function treesitter_try_attach(buf, language)
	if not vim.treesitter.language.add(language) then
		return
	end

	vim.treesitter.start(buf, language)

	if vim.treesitter.query.get(language, "indents") ~= nil then
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end
end

vim.api.nvim_create_autocmd("FileType", {
	callback = function(args)
		local language = vim.treesitter.language.get_lang(args.match)

		if not language then
			return
		end

		local buf = args.buf

		if
			vim.tbl_contains(nvim_treesitter.get_available(), language)
			and not vim.tbl_contains(nvim_treesitter.get_installed("parsers"), language)
		then
			nvim_treesitter.install(language):await(function()
				treesitter_try_attach(buf, language)
			end)
		else
			treesitter_try_attach(buf, language)
		end
	end,
})
