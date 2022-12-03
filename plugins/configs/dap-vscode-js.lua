local M = {}

M.setup = function()
	require("dap-vscode-js").setup({
		-- node_path = "node", -- Path of node executable. Defaults to $NODE_PATH, and then "node"
		debugger_path = vim.fn.stdpath("data") .. "/mason/bin", -- Path to vscode-js-debug installation.
		-- debugger_cmd = { "js-debug-adapter" }, -- Command to use to launch the debug server. Takes precedence over `node_path` and `debugger_path`.
		adapters = { "pwa-node", "pwa-chrome", "pwa-msedge", "node-terminal", "pwa-extensionHost" }, -- which adapters to register in nvim-dap
	})
end

return M
