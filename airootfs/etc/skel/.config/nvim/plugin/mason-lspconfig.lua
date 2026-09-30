vim.pack.add({ "https://github.com/mason-org/mason-lspconfig.nvim.git" })

require("mason-lspconfig").setup({ ensure_installed = { "bashls" } })
