return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"mason-org/mason-registry",
	},
	config = function()
		local dap = require("dap")
		local mason_registry = require("mason-registry")

		-- C# debugging
		dap.adapters.netcoredbg = {
			type = "executable",
			command = "netcoredbg",
			args = { "--interpreter=vscode" },
		}
		dap.configurations.cs = {
			{
				type = "netcoredbg",
				name = "Launch - netcoredbg",
				request = "launch",
				program = function()
					return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
				end,
			},
		}
	end,
}
