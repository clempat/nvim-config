local colorschemeName = nixCats("colorscheme")

return {
	{
		"lualine.nvim",
		for_cat = "general.always",
		-- cmd = { "" },
		event = "DeferredUIEnter",
		-- ft = "",
		-- keys = "",
		-- colorscheme = "",
		load = function(name)
			vim.cmd.packadd(name)
			vim.cmd.packadd("copilot-lualine")
			vim.cmd.packadd("lsp_progress")
		end,
		after = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = colorschemeName,
					component_separators = "|",
					section_separators = "",
				},
				sections = {
					lualine_c = {
						{
							"filename",
							path = 1,
							status = true,
						},
					},
				},
				inactive_sections = {
					lualine_b = {
						{
							"filename",
							path = 3,
							status = true,
						},
					},
					lualine_x = { "copilot", "filetype" },
				},
				tabline = {
					lualine_a = { "buffers" },
					-- if you use lualine-lsp-progress, I have mine here instead of fidget
					lualine_b = { "lsp_progress" },
					lualine_z = { "tabs" },
				},
			})
		end,
	},
}
