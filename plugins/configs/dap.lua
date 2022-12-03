local M = {}
local dap = require("dap")

M.setup = function()
	dap.defaults.fallback.external_terminal = {
		command = "/opt/homebrew/bin/kitty",
		args = { "-e" },
	}

	require("dap.ext.vscode").load_launchjs(nil, { coreclr = { "cs" } })

	dap.adapters.coreclr = {
		type = "executable",
		command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
		args = { "--interpreter=vscode" },
	}

	dap.configurations.javascript = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Launch file",
			program = "${file}",
			cwd = "${workspaceFolder}",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach",
			processId = require("dap.utils").pick_process,
			cwd = "${workspaceFolder}",
		},
	}

	dap.configurations.typescript = {
		{
			type = "pwa-node",
			request = "launch",
			name = "Debug Typescript file",
			runtimeExecutable = "node",
			args = {
				"${file}",
			},
			runtimeArgs = {
				"--nolazy",
				"-r",
				"ts-node/register",
				"-r",
				"tsconfig-paths/register",
			},
			sourceMaps = true,
			envFile = "${workspaceFolder}/.env",
			cwd = vim.fn.getcwd(),
			console = "integratedTerminal",
			protocol = "inspector",
		},
		{
			type = "pwa-node",
			request = "launch",
			runtimeExecutable = "node",
			name = "Debug Typescript NestJS",
			args = {
				"./src/main.ts",
			},
			runtimeArgs = {
				"--nolazy",
				"-r",
				"ts-node/register",
				"-r",
				"tsconfig-paths/register",
			},
			sourceMaps = true,
			envFile = "${workspaceFolder}/.env",
			cwd = vim.fn.getcwd(),
			console = "integratedTerminal",
			protocol = "inspector",
		},
		{
			type = "pwa-node",
			request = "attach",
			name = "Attach NestJS WS",
			port = 9229,
			restart = true,
			stopOnEntry = false,
			protocol = "inspector",
		},
	}
end

return M
