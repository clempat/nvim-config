return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		plugins = { spelling = true },
		defaults = {
			mode = { "n", "v" },
			-- {"g", group = "goto" },
			-- {"gs", group = "surround" },
			-- {"z", group = "fold" },
			-- {"]", group = "next" },
			-- {"[", group = "prev" },
			-- {"<leader>b", group = "buffer" },
			-- {"<leader>c", group = "code" },
			-- {"<leader>f", group = "file/find" },
			-- {"<leader>g", group = "git" },
			-- {"<leader>gh", group = "hunks" },
			-- {"<leader>q", group = "quit/session" },
			-- {"<leader>s", group = "search" },
			-- {"<leader>u", group = "ui" },
			-- {"<leader>w", group = "windows" },
			-- {"<leader>x", group = "diagnostics/quickfix" },
		},
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.register(opts.defaults)
	end,
}
