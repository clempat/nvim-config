return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		{ "ThePrimeagen/git-worktree.nvim" },
		{ "nvim-telescope/telescope-file-browser.nvim" },
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local function telescope_buffer_dir()
			return vim.fn.expand("%:p:h")
		end

		telescope.setup({
			defaults = {
				path_display = { "truncate " },
				winblend = 10,
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			extensions = {
				file_browser = {
					path = "%:p:h",
					cwd = telescope_buffer_dir(),
					respect_gitignore = false,
					hidden = true,
					grouped = true,
					previewer = false,
					initial_mode = "normal",
					layout_config = { height = 40 },
				},
			},
		})

		-- load plugins
		telescope.load_extension("fzf")
		telescope.load_extension("git_worktree")

		-- set keymaps
		local keymap = vim.keymap

		keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "[F]d recently [O]pened files" })
		keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "[F]ind [G]it files" })
		keymap.set("n", "<leader>fw", "<cmd>Telescope live_grep<cr>", { desc = "[F]ind current [W]ord" })
		keymap.set("n", "<leader>fs", "<cmd>Telescope grep_string<cr>", { desc = "[F]ind [S]tring in cwd" })
		keymap.set("n", "<leader>fd", "<cmd>Telescope diagnostics<cr>", { desc = "[F]ind [D]iagnostics" })
		keymap.set(
			"n",
			"<leader>gw",
			require("telescope").extensions.git_worktree.git_worktrees,
			{ desc = "Open [G]it [W]orktree" }
		)
		keymap.set(
			"n",
			"<leader>gn",
			require("telescope").extensions.git_worktree.create_git_worktree,
			{ desc = "[G]it [N]ew Branch" }
		)
		vim.keymap.set(
			"n",
			"<leader>pv",
			require("telescope").extensions.file_browser.file_browser,
			{ desc = "Open find browser" }
		)
	end,
}
