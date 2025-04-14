return {
	{
		"copilot.lua",
		for_cat = "ai",
		event = "DeferredUIEnter",
		after = function()
			require("copilot").setup({
				suggestion = {
					enabled = true,
					auto_trigger = true,
					keymap = {
						accept = "<C-l>",
						accept_word = "<C-k>",
					},
				},
				copilot_node_command = vim.env.NODE_PATH,
			})
		end,
	},
	{
		"codecompanion.nvim",
		for_cat = "ai",
		event = "DeferredUIEnter",
		after = function()
			require("codecompanion").setup({
				litellm = function()
					return require("codecompanion.adapters").extend("openai_compatible", {
						env = {
							url = "http://192.168.40.54:4000",
							api_key = "cmd:op read op://Private/litellm/LITELLM_API_KEY --no-newline",
						},
					})
				end,
			})
		end,
	},
}
