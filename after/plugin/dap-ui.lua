local ok_dap, dap = pcall(require, "dap")
local ok_dapui, dapui = pcall(require, "dap-ui")

if not (ok_dap and ok_dapui) then
	return
end

dap.listeners.after.event_initialized["dapui_config"] = function()
	dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
	dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
	dapui.close()
end
