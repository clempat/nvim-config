local ok_dap, dap = pcall(require, "dap")
local ok_dap_utils, dap_utils = pcall(require, "dap.utils")
local ok_dap_vscode_js, dap_vscode_js = pcall(require, "dap-vscode-js")
local ok_mason, mason_registry = pcall(require, "mason-registry")
local ok_utils, utils = pcall(require, "clement.utils")

if not (ok_dap and ok_dap_utils and ok_dap_vscode_js and ok_mason and ok_utils) then
  if not ok_dap then print("DAP: ❌") end
  if not ok_dap_utils then print("DAP-Utils: ❌") end
  if not ok_dap_vscode_js then print("DAP-VSCode-JS: ❌") end
  if not ok_mason then print("Mason: ❌") end
  if not ok_utils then print("Utils: ❌") end
  return
end


mason_registry.refresh()
mason_registry.update()
-- local path = mason_registry.get_package("netcoredbg"):get_install_path() .. "/build/netcoredbg"

dap_vscode_js.setup({
  node_path = "node",
  -- debugger_path = os.getenv("HOME") .. "/.DAP/vscode-js-debug", Using packer installation
  adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" },
})

local exts = {
  "javascript",
  "typescript",
  "javascriptreact",
  "typescriptreact",
  -- using pwa-chrome
  "vue",
  "svelte",
}

for i, ext in ipairs(exts) do
  dap.configurations[ext] = {
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File (pwa-node)",
      cwd = vim.fn.getcwd(),
      args = { "${file}" },
      sourceMaps = true,
      protocol = "inspector",
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File (pwa-node with ts-node)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "--loader", "ts-node/esm" },
      runtimeExecutable = "node",
      args = { "${file}" },
      sourceMaps = true,
      protocol = "inspector",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
      resolveSourceMapLocations = {
        "${workspaceFolder}/**",
        "!**/node_modules/**",
      },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Current File (pwa-node with deno)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "run", "--inspect-brk", "--allow-all", "${file}" },
      runtimeExecutable = "deno",
      attachSimplePort = 5555,
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with jest)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "${workspaceFolder}/node_modules/.bin/jest" },
      runtimeExecutable = "node",
      args = { "${file}", "--coverage", "false" },
      rootPath = "${workspaceFolder}",
      sourceMaps = true,
      console = "integratedTerminal",
      internalConsoleOptions = "neverOpen",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with vitest)",
      cwd = vim.fn.getcwd(),
      program = "${workspaceFolder}/node_modules/vitest/vitest.mjs",
      args = { "--inspect-brk", "--threads", "false", "run", "${file}" },
      autoAttachChildProcesses = true,
      smartStep = true,
      console = "integratedTerminal",
      skipFiles = { "<node_internals>/**", "node_modules/**" },
    },
    {
      type = "pwa-node",
      request = "launch",
      name = "Launch Test Current File (pwa-node with deno)",
      cwd = vim.fn.getcwd(),
      runtimeArgs = { "test", "--inspect-brk", "--allow-all", "${file}" },
      runtimeExecutable = "deno",
      attachSimplePort = 5555,
    },
    {
      type = "pwa-chrome",
      request = "attach",
      name = "Attach Program (pwa-chrome, select port)",
      program = "${file}",
      cwd = vim.fn.getcwd(),
      sourceMaps = true,
      port = function()
        return vim.fn.input("Select port: ", 9222)
      end,
      webRoot = "${workspaceFolder}",
    },
    -- {
    --   type = "node2",
    --   request = "attach",
    --   name = "Attach Program (Node2)",
    --   processId = dap_utils.pick_process,
    -- },
    -- {
    --   type = "node2",
    --   request = "attach",
    --   name = "Attach Program (Node2 with ts-node)",
    --   cwd = vim.fn.getcwd(),
    --   sourceMaps = true,
    --   skipFiles = { "<node_internals>/**" },
    --   port = 5555,
    -- },
    {
      type = "pwa-node",
      request = "attach",
      name = "Attach Program (pwa-node, select pid)",
      cwd = vim.fn.getcwd(),
      processId = dap_utils.pick_process,
      skipFiles = { "<node_internals>/**" },
    },
  }
end

-- C# .NET
dap.adapters.coreclr = {
  type = "executable",
  -- Check if I can dynamically read from mason
  command = os.getenv("HOME") .. "/.local/share/nvim/mason/packages/netcoredbg/build/netcoredbg",
  args = { "--interpreter=vscode" },
}
-- Neotest requires a netcoredbg adapter for some reason.
dap.adapters.netcoredbg = dap.adapters.coreclr
dap.configurations.cs = {
  {
    type = "coreclr",
    name = "launch - netcoredbg",
    request = "launch",
    justMyCode = false,
    args = {
      "--urls=https://localhost:7035/",
    },
    cwd = "{workspaceFolder}",
    env = {
      ASPNETCORE_ENVIRONMENT = "Development",
    },
    program = function()
      utils.dotnet_build_project()
      return utils.get_debug_program()
    end,
  },
}
