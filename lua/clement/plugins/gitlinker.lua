return {
	"ruifm/gitlinker.nvim",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("gitlinker").setup({
			callbacks = {
				["ssh.dev.azure.com"] = function(url_data)
					local parts = vim.split(url_data.repo, "/")
					local org = parts[2]
					local project = parts[3]
					local repo = parts[4]
					local url = "https://dev.azure.com/"
						.. org
						.. "/"
						.. project
						.. "/_git/"
						.. repo
						.. "?path=/"
						.. require("clement.core.helpers").urlencode(url_data.file)
						.. "&version=GC"
						.. url_data.rev
						.. "&lineStartColumn=1&lineEndColumn=1&lineStyle=plain&_a=contents"

					if url_data.lstart then
						url = url .. "&line=" .. url_data.lstart

						if url_data.lend then
							url = url .. "&lineEnd=" .. url_data.lend
						end
					end
					return url
				end,
			},
		})
		vim.api.nvim_set_keymap(
			"n",
			"<leader>gY",
			'<cmd>lua require"gitlinker".get_repo_url()<cr>',
			{ silent = true, desc = "Copy Git link of current line" }
		)
		vim.api.nvim_set_keymap(
			"n",
			"<leader>gB",
			'<cmd>lua require"gitlinker".get_repo_url({action_callback = require"gitlinker.actions".open_in_browser})<cr>',
			{ silent = true }
		)
	end,
}
