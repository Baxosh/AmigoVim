local M = {}

local tunnel_configs = {
  leto = { local_port = 15432, remote_port = 5433, host = "leto" },
  grms = { local_port = 15433, remote_port = 5433, host = "grms" },
  cloud = { local_port = 15434, remote_port = 5433, host = "cloud" },
}

-- Опции живучести: без них ssh не замечает, что соединение уже мертво,
-- и туннель "висит" до первого запроса.
local ssh_opts = {
  "-o",
  "ServerAliveInterval=30", -- пинг раз в 30 сек
  "-o",
  "ServerAliveCountMax=3", -- 3 пропуска подряд -> рвём и переподключаемся
  "-o",
  "TCPKeepAlive=yes",
  "-o",
  "ExitOnForwardFailure=yes", -- порт занят -> честно падаем, а не молча
  "-o",
  "ConnectTimeout=10",
  "-N",
}

local MAX_RETRIES = 5
local STABLE_AFTER = 30 -- сек: туннель прожил столько -> считаем перезапуск успешным

local tunnels = {} -- [server] = { job, retries, started_at, timer }
local shutting_down = false

local function port_is_listening(port)
  local out = vim.fn.system({ "lsof", "-nP", "-tiTCP:" .. port, "-sTCP:LISTEN" })
  return vim.v.shell_error == 0 and out:match("%d") ~= nil
end

local start_tunnel

local function schedule_retry(server, state)
  if shutting_down or state.retries >= MAX_RETRIES then
    if not shutting_down then
      vim.notify(
        ("SSH tunnel %s: не удалось поднять за %d попыток"):format(server, MAX_RETRIES),
        vim.log.levels.ERROR
      )
    end
    return
  end

  state.retries = state.retries + 1
  local delay = math.min(2 ^ state.retries, 30) * 1000 -- 2,4,8,16,30 сек

  state.timer = vim.defer_fn(function()
    if not shutting_down then
      start_tunnel(server)
    end
  end, delay)
end

start_tunnel = function(server)
  local config = tunnel_configs[server]
  if not config then
    vim.notify("Нет конфигурации туннеля для сервера: " .. server, vim.log.levels.ERROR)
    return
  end

  -- Кто-то (прошлый nvim, autossh, ручной ssh) уже держит порт — не мешаем.
  if port_is_listening(config.local_port) then
    return
  end

  local state = tunnels[server] or { retries = 0 }
  tunnels[server] = state

  local stderr = {}
  local cmd = { "ssh" }
  vim.list_extend(cmd, ssh_opts)
  vim.list_extend(cmd, {
    "-L",
    config.local_port .. ":localhost:" .. config.remote_port,
    config.host,
  })

  state.started_at = os.time()
  state.job = vim.fn.jobstart(cmd, {
    detach = false,
    on_stderr = function(_, data)
      for _, line in ipairs(data or {}) do
        if line ~= "" then
          table.insert(stderr, line)
        end
      end
    end,
    on_exit = function(_, code)
      state.job = nil
      if shutting_down then
        return
      end

      -- Прожил достаточно долго -> это обрыв, а не ошибка конфига: счётчик сбрасываем.
      if os.time() - state.started_at >= STABLE_AFTER then
        state.retries = 0
      end

      local reason = #stderr > 0 and (": " .. stderr[#stderr]) or ""
      vim.notify(
        ("SSH tunnel %s упал (код %d)%s — переподключаюсь"):format(server, code, reason),
        vim.log.levels.WARN
      )
      schedule_retry(server, state)
    end,
  })

  if state.job <= 0 then
    vim.notify("Не удалось запустить ssh для " .. server, vim.log.levels.ERROR)
    state.job = nil
    schedule_retry(server, state)
  end
end

local function ensure_ssh_tunnel(server)
  local state = tunnels[server]
  if state and state.job then
    -- jobwait с таймаутом 0 возвращает -1, пока процесс жив
    if vim.fn.jobwait({ state.job }, 0)[1] == -1 then
      return
    end
  end
  if state then
    state.retries = 0
  end
  start_tunnel(server)
end

local function stop_all_tunnels()
  shutting_down = true
  for _, state in pairs(tunnels) do
    if state.timer then
      pcall(function()
        state.timer:stop()
      end)
    end
    if state.job then
      vim.fn.jobstop(state.job)
    end
  end
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

        for server in pairs(tunnel_configs) do
          ensure_ssh_tunnel(server)
        end
        vim.cmd("DBUIToggle")
      end,
      desc = "Toggle DBUI (leto/grms/cloud SSH tunnels)",
    },
  },
  init = function()
    -- Внешний вид дерева
    vim.g.db_ui_use_nerd_fonts = 1
    vim.g.db_ui_win_position = "left"
    vim.g.db_ui_winwidth = 40

    -- Где хранятся сохранённые подключения и запросы
    vim.g.db_ui_save_location = "~/.local/share/db_ui"
    vim.g.db_ui_tmp_query_location = "~/.local/share/db_ui/tmp"

    -- Подхватывать подключение из переменных окружения (.env проекта)
    vim.g.db_ui_env_variable_url = "DATABASE_URL"
    vim.g.db_ui_env_variable_name = "DATABASE_NAME"

    -- Поменьше шума в сообщениях
    vim.g.db_ui_show_notifications = 0
    vim.g.db_ui_force_echo_notifications = 0

    -- Не выполнять запрос автоматически при :w
    vim.g.db_ui_execute_on_save = 0

    -- Сразу выполнять хелперы таблиц (Columns, Indexes и т.д.)
    vim.g.db_ui_auto_execute_table_helpers = 1
  end,

  config = function()
    vim.api.nvim_create_autocmd("VimLeavePre", { callback = stop_all_tunnels })

    vim.api.nvim_create_user_command("DBTunnels", function()
      local lines = {}
      for server, cfg in pairs(tunnel_configs) do
        local state = tunnels[server]
        local alive = state and state.job and vim.fn.jobwait({ state.job }, 0)[1] == -1
        local status = alive and "up" or (port_is_listening(cfg.local_port) and "up (внешний)" or "down")
        table.insert(
          lines,
          ("%-6s :%d -> %s:%d  [%s]"):format(server, cfg.local_port, cfg.host, cfg.remote_port, status)
        )
      end
      table.sort(lines)
      vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
    end, { desc = "Статус SSH-туннелей DBUI" })

    vim.api.nvim_create_user_command("DBTunnelsRestart", function()
      stop_all_tunnels()
      shutting_down = false
      vim.defer_fn(function()
        for server in pairs(tunnel_configs) do
          ensure_ssh_tunnel(server)
        end
      end, 500)
    end, { desc = "Перезапустить SSH-туннели DBUI" })
  end,
}

return { M.plugin }
