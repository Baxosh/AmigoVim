local M = {}

local ssh_tunnel_job = nil

local function ensure_ssh_tunnel()
  if ssh_tunnel_job then
    local status = vim.fn.jobwait({ ssh_tunnel_job }, 0)[1]
    if status == -1 then
      return
    end
  end
  ssh_tunnel_job = vim.fn.jobstart({
    "ssh",
    "-NL",
    "15432:localhost:5433",
    "leto",
  }, { detach = false })
end

M.plugin = {
  "kristijanhusak/vim-dadbod-ui",
  dependencies = { "tpope/vim-dadbod" },
  cmd = { "DBUI", "DBUIToggle", "DBUIAddConnection", "DBUIFindBuffer" },
  keys = {
    {
      "<leader>D",
      function()
        -- Close Dashboard
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.bo[buf].filetype == "snacks_dashboard" then
            vim.api.nvim_buf_delete(buf, { force = true })
          end
        end

        ensure_ssh_tunnel()
        vim.cmd("DBUIToggle")
      end,
      desc = "Toggle DBUI with SSH tunnel",
    },
  },
  config = function()
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        if ssh_tunnel_job then
          vim.fn.jobstop(ssh_tunnel_job)
        end
      end,
    })
  end,
}

return { M.plugin }
