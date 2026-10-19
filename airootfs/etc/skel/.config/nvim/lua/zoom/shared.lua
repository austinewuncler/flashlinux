local severity = vim.diagnostic.severity

return {
  diagnostic_signs = {
    [severity.ERROR] = " ",
    [severity.HINT] = " ",
    [severity.INFO] = " ",
    [severity.WARN] = " ",
  },
}
