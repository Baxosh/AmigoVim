-- Set third-party files as read-only automatically
local function make_readonly()
  local filepath = vim.fn.expand("%:p")
  if filepath:match("site%-packages") or filepath:match("node_modules") then
    vim.bo.readonly = true
    vim.bo.modifiable = false
    vim.api.nvim_echo({ { "Read-only: Third-party file", "WarningMsg" } }, false, {})
  end
end

-- Register the autocmd for BufReadPre event
vim.api.nvim_create_autocmd("BufReadPre", {
  group = vim.api.nvim_create_augroup("ReadonlyThirdParty", { clear = true }),
  pattern = "*",
  callback = make_readonly,
})
