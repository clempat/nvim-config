return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		dependencies = {
			"nvim-treesitter/nvim-treesitter-textobjects",
			"windwp/nvim-ts-autotag",
			"nvim-treesitter/nvim-treesitter-context",
		},
		config = function()
			-- import nvim-treesitter plugin
			local treesitter = require("nvim-treesitter.configs")
			local context = require("treesitter-context")

			-- configure treesitter
			treesitter.setup({ -- enable syntax highlighting
				highlight = {
					enable = true,
				},
				-- enable indentation
				indent = { enable = true },
				-- enable autotagging (w/ nvim-ts-autotag plugin)
				autotag = {
					enable = true,
				},
				-- ensure these language parsers are installed
				ensure_installed = {
					"bash",
					"c",
					"c_sharp",
					"css",
					"dockerfile",
					"gitignore",
					"go",
					"gomod",
					"gosum",
					"gowork",
					"gotmpl",
					"gohtmltmpl",
					"graphql",
					"html",
					"javascript",
					"json",
					"lua",
					"markdown",
					"markdown_inline",
					"nix",
					"prisma",
					"python",
					"query",
					"svelte",
					"terraform",
					"tsx",
					"typescript",
					"vim",
					"vue",
					"yaml",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
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
