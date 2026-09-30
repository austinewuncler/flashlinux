local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
	return vim.api.nvim_create_augroup(name, { clear = true })
end

autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
	callback = function()
		if vim.o.buftype ~= "nofile" then
			vim.cmd("checktime")
		end
	end,
	group = augroup("checktime"),
})

autocmd("TextYankPost", {
	callback = function()
		if vim.fn.has("nvim-0.13") == 1 then
			vim.hl.hl_op()
		else
			vim.hl.on_yank()
		end
	end,
	group = augroup("highlight_yank"),
})

autocmd("BufReadPost", {
	callback = function(event)
		local buf = event.buf

		if vim.tbl_contains({ "gitcommit" }, vim.bo[buf].filetype) or vim.b[buf].last_loc then
			return
		end

		vim.b[buf].last_loc = true

		local mark = vim.api.nvim_buf_get_mark(buf, '"')

		if mark[1] > 0 and mark[1] <= vim.api.nvim_buf_line_count(buf) then
			pcall(vim.api.nvim_win_set_cursor, 0, mark)
		end
	end,
	group = augroup("last_loc"),
})

autocmd("FileType", {
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "q", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, { buffer = event.buf, desc = "Quit buffer", silent = true })
		end)
	end,
	group = augroup("close_with_q"),
	pattern = { "help" },
})

autocmd({ "BufWritePre" }, {
	callback = function(event)
		if event.match:match("^%w%w+:[\\/][\\/]") then
			return
		end

		vim.fn.mkdir(vim.fn.fnamemodify(vim.uv.fs_realpath(event.match) or event.match, ":p:h"), "p")
	end,
	group = augroup("auto_create_dir"),
})
