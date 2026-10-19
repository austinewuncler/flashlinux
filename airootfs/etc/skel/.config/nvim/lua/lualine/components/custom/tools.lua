return function()
	return table.concat(vim.tbl_map(function()
		local icon = "󰈺"
		local _, hl = require("mini.icons").get("filetype", "mason")

		return "%#" .. hl .. "#" .. icon .. " "
	end, require("conform").list_formatters_for_buffer()))
end
