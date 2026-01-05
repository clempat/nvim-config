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
						{
							desc = "󰈞 Find Files",
							group = "Label",
							action = function()
								local ok, smart_open = pcall(require, "telescope._extensions.smart_open")
								if ok then
									require("telescope").extensions.smart_open.smart_open()
								else
									require("telescope.builtin").find_files()
								end
							end,
							key = "f",
						},
						{
							desc = " Recent Files",
							group = "Number",
							action = function()
								require("telescope.builtin").oldfiles()
							end,
							key = "r",
						},
						{
							desc = " Find Text",
							group = "@property",
							action = function()
								require("telescope.builtin").live_grep()
							end,
							key = "g",
						},
						{ desc = " New File", group = "DiagnosticHint", action = "ene | startinsert", key = "n" },
						{ desc = " Configuration", group = "Special", action = "edit $MYVIMRC", key = "c" },
						{ desc = " Quit", group = "Error", action = "quit", key = "q" },
					},
				},
			})
		end,
	},
}
