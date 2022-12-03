-- MAPPINGS
local M = {}

M.all = {
	n = {
		["<C-p>"] = { "<cmd>Telescope find_files <CR>", "Find Files with Telescope" },
		["<leader>a"] = {
			function()
				require("harpoon.mark").add_file()
			end,
			"Add mark to harpoon",
		},
		["<C-e>"] = { ":Telescope harpoon marks <CR>", "List marks from harpoon" },
		["<c-u>"] = { "i<c-r>=trim(system('uuidgen'))<cr><esc>", "Generate uuid when normal mode" },
		["<leader>gw"] = {
			"<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>",
			"List of branches",
		},
		["<c-t>"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"Toggle float terminal",
		},
		["<C-f>"] = { ":Telescope projects <CR>", "Projects switch" },
	},
	i = {
		["<c-u>"] = { "<c-r>=trim(system('uuidgen'))<cr>", "Generate uuid when insert mode" },
		["jk"] = { "<ESC>", "Escape with jk" },
		["<c-t>"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"Toggle float terminal",
		},

		["<C-f>"] = { ":Telescope projects <CR>", "Projects switch" },
	},
	t = {
		["<c-t>"] = {
			function()
				require("nvterm.terminal").toggle("float")
			end,
			"Toggle float terminal",
		},
		["<C-f>"] = { ":Telescope projects <CR>", "Projects switch" },
	},
}

return M
