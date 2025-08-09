local M = {}

local ssh_tunnel_jobs = {}

local function ensure_ssh_tunnel(server)
  local tunnel_configs = {
    leto = {
      local_port = 15432,
      remote_port = 5433,
      host = "leto",
    },
    -- Add your new server here
    grms = {
      local_port = 15433,
      remote_port = 5433,
      host = "grms",
    },
  }

  local config = tunnel_configs[server]
  if not config then
    vim.notify("No tunnel configuration for server: " .. server, vim.log.levels.ERROR)
    return
  end

  if ssh_tunnel_jobs[server] then
    local status = vim.fn.jobwait({ ssh_tunnel_jobs[server] }, 0)[1]
    if status == -1 then
      return
    end
  end

  ssh_tunnel_jobs[server] = vim.fn.jobstart({
    "ssh",
    "-NL",
    config.local_port .. ":localhost:" .. config.remote_port,
    config.host,
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

        ensure_ssh_tunnel("leto")
        ensure_ssh_tunnel("grms")
        vim.cmd("DBUIToggle")
      end,
      desc = "Toggle DBUI with Leto SSH tunnel",
    },
  },
  config = function()
    vim.api.nvim_create_autocmd("VimLeavePre", {
      callback = function()
        for _, job in pairs(ssh_tunnel_jobs) do
          if job then
            vim.fn.jobstop(job)
          end
        end
      end,
    })
  end,
}

return { M.plugin }
