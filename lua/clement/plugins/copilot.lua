return {
	"github/copilot.vim",
	build = ":Copilot auth",
	config = function()
		local copilot = require("copilot")
		---@diagnostic disable-next-line: undefined-field
		local node_path = _G.nodejs

		-- if node_path then
		-- 	vim.notify("Using Node.js at: " .. node_path, vim.log.levels.INFO)
		-- else
		-- 	vim.notify("NEOVIM_NODE_PATH not set!", vim.log.levels.WARN)
		-- end

		copilot.setup({
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<C-space>",
				},
			},
			copilot_node_command = node_path,
		})
	end,
}
