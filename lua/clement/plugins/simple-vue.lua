return {
	{
		"neovim/nvim-lspconfig",
		for_cat = "frontend",
		ft = "vue",
		after = function()
			local lspconfig = require('lspconfig')
			
			-- Simple vtsls setup with Vue plugin
			lspconfig.vtsls.setup({
				filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
				settings = {
					vtsls = {
						tsserver = {
							globalPlugins = {
								{
									name = "@vue/typescript-plugin",
									location = require('lspconfig.util').find_node_modules_ancestor('.') .. "/@vue/language-server",
									languages = { "vue" },
									configNamespace = "typescript",
								},
							},
						},
					},
				},
			})
			
			-- Simple Vue Language Server setup
			lspconfig.volar.setup({
				filetypes = { "vue" },
				init_options = {
					vue = {
						hybridMode = false,
					},
				},
			})
		end,
	},
}