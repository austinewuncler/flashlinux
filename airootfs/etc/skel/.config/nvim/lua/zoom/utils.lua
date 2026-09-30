local diagnostic_severity = vim.diagnostic.severity

return {
  diagnostic_signs = {
    [diagnostic_severity.ERROR] = " ",
    [diagnostic_severity.HINT] = " ",
    [diagnostic_severity.INFO] = " ",
    [diagnostic_severity.WARN] = " ",
  },
}
