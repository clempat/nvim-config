return {
	{
		"vim-dadbod-ui",
		for_cat = "database",
		event = "DeferredUIEnter",
		after = function()
			vim.g.db_ui_use_nerd_fonts = 1
		end,
	},
	{ "vim-dadbod-completion", for_cat = "database", event = "DeferredUIEnter" },
	{
		"vim-dadbod",
		for_cat = "database",
		event = "DeferredUIEnter",
		dep_of = { "vim-dadbod-ui", "vim-dadbod-completion" },
	},
}
