local map = vim.keymap.set

map({ "i", "n" }, "<left>", '<cmd>echo "use h to move!"<cr>')
map({ "i", "n" }, "<down>", '<cmd>echo "use j to move!"<cr>')
map({ "i", "n" }, "<up>", '<cmd>echo "use k to move!"<cr>')
map({ "i", "n" }, "<right>", '<cmd>echo "use l to move!"<cr>')

map("i", "<c-h>", "<left>")
map("i", "<c-j>", "<down>")
map("i", "<c-k>", "<up>")
map("i", "<c-l>", "<right>")

map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

map("n", "<c-h>", "<c-w>h", { remap = true })
map("n", "<c-j>", "<c-w>j", { remap = true })
map("n", "<c-k>", "<c-w>k", { remap = true })
map("n", "<c-l>", "<c-w>l", { remap = true })

map("n", "<a-j>", "<cmd>execute 'move .+' . v:count1<cr>==")
map("n", "<a-k>", "<cmd>execute 'move .-' . (v:count1 + 1)<cr>==")

map({ "i", "n" }, "<esc>", "<cmd>nohlsearch<cr><esc>")
map({ "i", "x", "n", "s" }, "<c-s>", "<cmd>w<cr><esc>")
