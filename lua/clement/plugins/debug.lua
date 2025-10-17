---@param config {args?:string[]|fun():string[]?}
local function get_args(config)
	local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
	config = vim.deepcopy(config)
	---@cast args string[]
	config.args = function()
		local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
		return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
	end
	return config
end

return {
	{
		"nvim-dap",
		for_cat = "debug",
		lazy = false,  -- Load nvim-dap eagerly to ensure it's available for other plugins
		keys = {
			{ "<leader>d", "", desc = "+debug", mode = { "n", "v" } },
			{
				"<leader>dB",
				function()
					require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{
				"<leader>db",
				function()
					require("dap").toggle_breakpoint()
				end,
				desc = "Toggle Breakpoint",
			},
			{
				"<leader>dc",
				function()
					require("dap").continue()
				end,
				desc = "Continue",
			},
			{
				"<leader>da",
				function()
					require("dap").continue({ before = get_args })
				end,
				desc = "Run with Args",
			},
			{
				"<leader>dC",
				function()
					require("dap").run_to_cursor()
				end,
				desc = "Run to Cursor",
			},
			{
				"<leader>dg",
				function()
					require("dap").goto_()
				end,
				desc = "Go to Line (No Execute)",
			},
			{
				"<leader>di",
				function()
					require("dap").step_into()
				end,
				desc = "Step Into",
			},
			{
				"<leader>dj",
				function()
					require("dap").down()
				end,
				desc = "Down",
			},
			{
				"<leader>dk",
				function()
					require("dap").up()
				end,
				desc = "Up",
			},
			{
				"<leader>dl",
				function()
					require("dap").run_last()
				end,
				desc = "Run Last",
			},
			{
				"<leader>do",
				function()
					require("dap").step_out()
				end,
				desc = "Step Out",
			},
			{
				"<leader>dO",
				function()
					require("dap").step_over()
				end,
				desc = "Step Over",
			},
			{
				"<leader>dp",
				function()
					require("dap").pause()
				end,
				desc = "Pause",
			},
			{
				"<leader>dr",
				function()
					require("dap").repl.toggle()
				end,
				desc = "Toggle REPL",
			},
			{
				"<leader>ds",
				function()
					require("dap").session()
				end,
				desc = "Session",
			},
			{
				"<leader>dt",
				function()
					require("dap").terminate()
				end,
				desc = "Terminate",
			},
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
		},
		after = function(plugin)
			-- Basic debugging keymaps
			local dap = require("dap")
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F1>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<F2>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F3>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>B", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Debug: Set Breakpoint" })

			-- Set DAP highlight and signs
			vim.api.nvim_set_hl(0, "DapStoppedLine", { default = true, link = "Visual" })
			local icons = {
				Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
				Breakpoint = " ",
				BreakpointCondition = " ",
				BreakpointRejected = { " ", "DiagnosticError" },
				LogPoint = ".>",
			}

			for name, sign in pairs(icons) do
				sign = type(sign) == "table" and sign or { sign }
				vim.fn.sign_define(
					"Dap" .. name,
					{ text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
				)
			end

			-- Configure language adapters
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "localhost",
				port = "${port}",
				executable = {
					command = "js-debug-adapter",
					args = { "${port}" },
				}
			}
			
			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch", 
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
				},
			}
			
			dap.configurations.typescript = dap.configurations.javascript
		end,
	},
	{
		"nvim-dap-ui",
		for_cat = "debug",
		event = "DeferredUIEnter",
		load = function(name)
			vim.cmd.packadd("nvim-dap-ui")
			vim.cmd.packadd("nvim-nio")  -- Required dependency
		end,
		keys = {
			{ "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
			{ "<leader>de", function() require("dapui").eval() end, desc = "Debug: Eval", mode = {"n", "v"} },
			{ "<F7>", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
		},
		after = function(plugin)
			local dapui = require("dapui")
			local dap = require("dap")

			dapui.setup({
				icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
				controls = {
					icons = {
						pause = "⏸",
						play = "▶",
						step_into = "⏎",
						step_over = "⏭",
						step_out = "⏮",
						step_back = "b",
						run_last = "▶▶",
						terminate = "⏹",
						disconnect = "⏏",
					},
				},
			})

			-- Auto-open/close DAP UI
			dap.listeners.after.event_initialized["dapui_config"] = dapui.open
			dap.listeners.before.event_terminated["dapui_config"] = dapui.close
			dap.listeners.before.event_exited["dapui_config"] = dapui.close
		end,
	},
	{
		"nvim-dap-virtual-text", 
		for_cat = "debug",
		event = "DeferredUIEnter",
		load = function(name)
			vim.cmd.packadd("nvim-dap-virtual-text")
		end,
		after = function(plugin)
			require("nvim-dap-virtual-text").setup({
				enabled = true,
				enabled_commands = true,
				highlight_changed_variables = true,
				highlight_new_as_changed = false,
				show_stop_reason = true,
				commented = false,
				only_first_definition = true,
				all_references = false,
				clear_on_continue = false,
				display_callback = function(variable, buf, stackframe, node, options)
					if options.virt_text_pos == "inline" then
						return " = " .. variable.value
					else
						return variable.name .. " = " .. variable.value
					end
				end,
				virt_text_pos = vim.fn.has("nvim-0.10") == 1 and "inline" or "eol",
				all_frames = false,
				virt_lines = false,
				virt_text_win_col = nil,
			})
		end,
	},
	{
		"nvim-dap-python",
		for_cat = "python_debug",
		ft = "python",
		after = function(plugin)
			local ok, dap_python = pcall(require, "dap-python")
			if not ok then
				vim.notify("Failed to load nvim-dap-python", vim.log.levels.ERROR)
				return
			end

			-- Setup with Python path - debugpy should be available in the environment
			dap_python.setup("python")
			
			-- Add custom Python configurations
			local ok_dap, dap = pcall(require, "dap")
			if ok_dap then
				table.insert(dap.configurations.python, {
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						local cwd = vim.fn.getcwd()
						if vim.fn.executable(cwd .. "/venv/bin/python") == 1 then
							return cwd .. "/venv/bin/python"
						elseif vim.fn.executable(cwd .. "/.venv/bin/python") == 1 then
							return cwd .. "/.venv/bin/python"
						else
							return "/usr/bin/python"
						end
					end,
				})
			end
		end,
	},
	{
		"nvim-dap-go",
		for_cat = "debug", 
		ft = "go",
		after = function(plugin)
			local ok, dap_go = pcall(require, "dap-go")
			if ok then
				dap_go.setup()
			else
				vim.notify("Failed to load nvim-dap-go", vim.log.levels.ERROR)
			end
		end,
	},
}
