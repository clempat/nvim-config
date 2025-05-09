return {
	{
		"nvim-treesitter",
		for_cat = "general.treesitter",
		-- cmd = { "" },
		event = "DeferredUIEnter",

		load = function(name)
			vim.cmd.packadd(name)
			vim.cmd.packadd("nvim-treesitter-textobjects")
			vim.cmd.packadd("nvim-ts-autotag")
			vim.cmd.packadd("nvim-treesitter-context")
		end,
		after = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")
			local context = require("treesitter-context")

			-- configure treesitter
			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				auto_install = true,
				-- enable indentation
				indent = { enable = true },
				-- enable autotagging (w/ nvim-ts-autotag plugin)
				autotag = {
					enable = true,
				},
				textobjects = {
					select = {
						enable = true,
						lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
						keymaps = {
							-- You can use the capture groups defined in textobjects.scm
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true, -- whether to set jumps in the jumplist
						goto_next_start = {
							["]m"] = "@function.outer",
							["]]"] = "@class.outer",
						},
						goto_next_end = {
							["]M"] = "@function.outer",
							["]["] = "@class.outer",
						},
						goto_previous_start = {
							["[m"] = "@function.outer",
							["[["] = "@class.outer",
						},
						goto_previous_end = {
							["[M"] = "@function.outer",
							["[]"] = "@class.outer",
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>a"] = "@parameter.inner",
						},
						swap_previous = {
							["<leader>A"] = "@parameter.inner",
						},
					},
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<c-space>",
						node_incremental = "<c-space>",
						scope_incremental = "<c-s>",
						node_decremental = "<M-space>",
					},
				},
			})

			-- enable treesitter context
			context.setup({
				enable = true,
			})
		end,
	},
}
