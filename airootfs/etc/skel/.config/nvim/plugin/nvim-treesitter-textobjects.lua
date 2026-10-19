vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter-textobjects.git" })

vim.g.no_plugin_maps = true

local TEXTOBJECTS = "nvim-treesitter-textobjects"

require(TEXTOBJECTS).setup()

local move = require(TEXTOBJECTS .. ".move")
local select = require(TEXTOBJECTS .. ".select")

local map = vim.keymap.set

map({ "x", "o" }, "af", function()
  select.select_textobject("@function.outer", "textobjects")
end, { desc = "function" })
map({ "x", "o" }, "if", function()
  select.select_textobject("@function.inner", "textobjects")
end, { desc = "function" })

map({ "n", "x", "o" }, "[f", function()
  move.goto_previous_start("@function.outer", "textobjects")
end, { desc = "previous function start" })
map({ "n", "x", "o" }, "[F", function()
  move.goto_previous_end("@function.outer", "textobjects")
end, { desc = "previous function end" })
map({ "n", "x", "o" }, "]f", function()
  move.goto_next_start("@function.outer", "textobjects")
end, { desc = "next function start" })
map({ "n", "x", "o" }, "]F", function()
  move.goto_next_end("@function.outer", "textobjects")
end, { desc = "next function end" })
