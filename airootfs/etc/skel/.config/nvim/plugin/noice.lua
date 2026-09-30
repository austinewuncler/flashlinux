vim.pack.add({ "https://github.com/MunifTanjim/nui.nvim.git", "https://github.com/folke/noice.nvim.git" })

require("noice").setup({
  cmdline = {
    format = {
      cmdline = { icon = "󰞷 " },
      filter = { icon = "󰈲 " },
      help = { icon = "󰋖" },
      input = { icon = "󰌌 " },
      lua = { icon = "󰢱 " },
      search_down = { icon = "󰍉 󰄼" },
      search_up = { icon = "󰍉 󰄿" },
    },
  },
  lsp = {
    hover = { enabled = false },
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
    },
    progress = { enabled = false },
    signature = { enabled = false },
  },
  presets = {
    bottom_search = true,
    command_palette = true,
    inc_rename = false,
    long_message_to_split = true,
    lsp_doc_border = false,
  },
})
