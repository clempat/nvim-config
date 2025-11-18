-- AI Plugins Configuration
-- CodeCompanion has 2 adapters:
--   - litellm (HTTP): Via LiteLLM proxy
--   - opencode (ACP): Built-in, MCP/tools/agents via `opencode auth`
-- Usage:
--   :CodeCompanionChat http/litellm (for LiteLLM)
--   :CodeCompanionChat acp/opencode (for OpenCode ACP, if available in your version)
-- MCP servers: mcphub.nvim (:MCPHub to toggle) + OpenCode's own config
--
-- To switch to Avante:
-- 1. flake.nix:304-306: swap commented plugin
-- 2. This file: swap config blocks (lines 43-75)
-- 3. keymaps.lua: swap keymaps (lines 22-30)
-- 4. Rebuild: nix run

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
				filetype = {
					markdown = true,
				},
			})
		end,
	},
	{
		"mcphub.nvim",
		for_cat = "ai",
		event = "DeferredUIEnter",
		before = function()
			vim.g.mcphub = {
				config = vim.fn.expand("~/.config/mcphub/servers.json"),
			}
		end,
	},
	{
		"codecompanion.nvim",
		for_cat = "ai",
		event = "DeferredUIEnter",
		after = function()
			require("codecompanion").setup({
				adapters = {
					http = {
						-- LiteLLM HTTP adapter
						litellm = function()
							return require("codecompanion.adapters").extend("openai_compatible", {
								env = {
									url = "http://192.168.40.54:4000",
									api_key = "cmd:op read --account patout.1password.com 'op://Private/Litellm/NVIM_LITELLM_API_KEY' --no-newline",
									chat_url = "/v1/chat/completions",
								},
								schema = {
									model = {
										default = "anthropic/claude-sonnet-4-5",
									},
								},
							})
						end,
					},
					-- acp section: opencode is built-in, no config needed
				},
				strategies = {
					chat = {
						opts = {
							completion_provider = "default",
						},
					},
				},
			})
		end,
	},
	-- Commented to test CodeCompanion ACP - switch to compare
	-- {
	-- 	"avante.nvim",
	-- 	for_cat = "ai",
	-- 	event = "DeferredUIEnter",
	-- 	after = function()
	-- 		require("avante").setup({
	-- 			provider = "opencode",
	-- 			acp_providers = {
	-- 				["opencode"] = {
	-- 					command = "opencode",
	-- 					args = { "acp" },
	-- 					env = {
	-- 						ANTHROPIC_API_KEY = "cmd:op read op://Private/litellm/LITELLM_API_KEY --no-newline",
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	-- 	end,
	-- },
}
