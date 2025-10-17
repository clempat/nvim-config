return {
	{
		"dashboard-nvim",
		for_cat = "general.always",
		event = "VimEnter",
		after = function()
			require("dashboard").setup({
				theme = "hyper",
				config = {
					week_header = {
						enable = true,
					},
					shortcut = {
						{ desc = "󰈞 Find Files", group = "Label", action = "Telescope find_files", key = "f" },
						{ desc = " Recent Files", group = "Number", action = "Telescope oldfiles", key = "r" },
						{ desc = " Find Text", group = "@property", action = "Telescope live_grep", key = "g" },
						{ desc = " New File", group = "DiagnosticHint", action = "ene | startinsert", key = "n" },
						{ desc = " Configuration", group = "Special", action = "edit $MYVIMRC", key = "c" },
						{ desc = " Quit", group = "Error", action = "quit", key = "q" },
					},
				},
			})
		end,
	},
}
