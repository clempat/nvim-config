return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		{
			"prochri/telescope-all-recent.nvim",
			dependencies = {
				"kkharji/sqlite.lua",
			},
			opts = {},
		},
		-- {
		-- 	"danielfalk/smart-open.nvim",
		-- 	branch = "0.2.x",
		-- 	dependencies = {
		-- 		"kkharji/sqlite.lua",
		-- 		{ "nvim-telescope/telescope-fzy-native.nvim" },
		-- 	},
		-- },
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
		"debugloop/telescope-undo.nvim",
		{ "ThePrimeagen/git-worktree.nvim" },
		{ "nvim-telescope/telescope-file-browser.nvim" },
		"vuki656/package-info.nvim",
		{
			"nvim-telescope/telescope-live-grep-args.nvim",
			version = "^1.0.0",
		},
	},
	config = function()
		local telescope = require("telescope")
		local actions = require("telescope.actions")
		local function telescope_buffer_dir()
			return vim.fn.expand("%:p:h")
		end

		telescope.setup({
			defaults = {
				file_ignore_patterns = {
					".git/",
					"node_modules",
					".cache/",
					".next/",
					".DS_Store",
					".vscode/",
					".venv/",
					".direnv/",
				},
				layout_config = {
					height = 0.90,
					width = 0.90,
					preview_cutoff = 0,
					horizontal = { preview_width = 0.60 },
					vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
					prompt_position = "top",
				},
				path_display = { "smart" },
				prompt_prefix = " ",
				selection_caret = " ",
				sorting_strategy = "ascending",
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--hidden",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--trim",
				},
				mappings = {
					i = {
						["<C-k>"] = actions.move_selection_previous, -- move to prev result
						["<C-j>"] = actions.move_selection_next, -- move to next result
						["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
					},
				},
			},
			pickers = {
				buffers = {
					prompt_prefix = "󰸩 ",
				},
				commands = {
					prompt_prefix = " ",
					layout_config = {
						height = 0.63,
						width = 0.78,
					},
				},
				command_history = {
					prompt_prefix = " ",
					layout_config = {
						height = 0.63,
						width = 0.58,
					},
				},
				git_files = {
					prompt_prefix = "󰊢 ",
					show_untracked = true,
				},
				find_files = {
					prompt_prefix = " ",
					find_command = { "fd", "-H" },
				},
				live_grep = {
					prompt_prefix = "󰱽 ",
				},
				grep_string = {
					prompt_prefix = "󰱽 ",
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
				["zf-native"] = {
					file = { -- options for sorting file-like items
						enable = true, -- override default telescope file sorter
						highlight_results = true, -- highlight matching text in results
						match_filename = true, -- enable zf filename match priority
					},
					generic = { -- options for sorting all other items
						enable = true, -- override default telescope generic item sorter
						highlight_results = true, -- highlight matching text in results
						match_filename = false, -- disable zf filename match priority
					},
				},
				-- smart_open = {
				-- 	cwd_only = true,
				-- 	filename_first = true,
				-- },
			},
		})

		-- load plugins
		telescope.load_extension("fzf")
		telescope.load_extension("git_worktree")
		telescope.load_extension("package_info")
		-- telescope.load_extension("smart_open")
		telescope.load_extension("undo")
		telescope.load_extension("live_grep_args")

		-- set keymaps
		local keymap = vim.keymap

		keymap.set("n", "<C-p>", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
		keymap.set("n", "<leader>fo", "<cmd>Telescope oldfiles<cr>", { desc = "[F]d recently [O]pened files" })
		keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<cr>", { desc = "[F]ind [G]it files" })
		keymap.set(
			"n",
			"<leader>fw",
			":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
			{ desc = "[F]ind current [W]ord" }
		)
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
