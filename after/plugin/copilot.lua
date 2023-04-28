local status, copilot = pcall(require, "copilot")
if (not status) then return end

copilot.setup({
	suggestion = {
		auto_trigger = true,
	},
	copilot_node_command = vim.fn.expand("$HOME") .. '/.nvm/versions/node/v18.16.0/bin/node', -- Node.js version must be > 16.x
})

local status2, copilot_cmp = pcall(require, "copilot_cmp")
if (not status2) then return end

copilot_cmp.setup()
