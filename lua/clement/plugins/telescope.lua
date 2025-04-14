-- Telescope is a fuzzy finder that comes with a lot of different things that
-- it can fuzzy find! It's more than just a "file finder", it can search
-- many different aspects of Neovim, your workspace, LSP, and more!
--
-- The easiest way to use telescope, is to start by doing something like:
--  :Telescope help_tags
--
-- After running this command, a window will open up and you're able to
-- type in the prompt window. You'll see a list of help_tags options and
-- a corresponding preview of the help.
--
-- Two important keymaps to use while in telescope are:
--  - Insert mode: <c-/>
--  - Normal mode: ?
--
-- This opens a window that shows you all of the keymaps for the current
-- telescope picker. This is really useful to discover what Telescope can
-- do as well as how to actually do it!

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`

-- Telescope live_grep in git root
-- Function to find the git root directory based on the current buffer's path
local function find_git_root()
	-- Use the current buffer's path as the starting point for the git search
	local current_file = vim.api.nvim_buf_get_name(0)
	local current_dir
	local cwd = vim.fn.getcwd()
	-- If the buffer is not associated with a file, return nil
	if current_file == "" then
		current_dir = cwd
	else
		-- Extract the directory from the current file's path
		current_dir = vim.fn.fnamemodify(current_file, ":h")
	end

	-- Find the Git root directory from the current file's path
	local git_root = vim.fn.systemlist("git -C " .. vim.fn.escape(current_dir, " ") .. " rev-parse --show-toplevel")[1]
	if vim.v.shell_error ~= 0 then
		print("Not a git repository. Searching on current working directory")
		return cwd
	end
	return git_root
end

-- Custom live_grep function to search in git root
local function live_grep_git_root()
	local git_root = find_git_root()
	if git_root then
		require("telescope.builtin").live_grep({
			search_dirs = { git_root },
		})
	end
end

return {
	"telescope.nvim",
	branch = "0.1.x",
	for_cat = "general.telescope",
	cmd = { "Telescope", "LiveGrepGitRoot" },
	-- NOTE: our on attach function defines keybinds that call telescope.
	-- so, the on_require handler will load telescope when we use those.
	on_require = { "telescope" },
	-- event = "",
	-- ft = "",
	load = function(name)
		vim.cmd.packadd(name)
		vim.cmd.packadd("telescope-fzf-native.nvim")
		vim.cmd.packadd("telescope-ui-select.nvim")
		vim.cmd.packadd("telescope-file-browser.nvim")
		vim.cmd.packadd("telescope-live-greo-args.nvim")
		vim.cmd.packadd("git-worktree.nvim")
		vim.cmd.packadd("package-info.nvim")
	end,

	keys = {
		{ "<leader>fM", "<cmd>Telescope notify<CR>", mode = { "n" }, desc = "[S]earch [M]essage" },
		{ "<leader>fp", live_grep_git_root, mode = { "n" }, desc = "[S]earch git [P]roject root" },
		{
			"<leader>/",
			function()
				-- Slightly advanced example of overriding default behavior and theme
				-- You can pass additional configuration to telescope to change theme, layout, etc.
				require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end,
			mode = { "n" },
			desc = "[/] Fuzzily search in current buffer",
		},
		{
			"<leader>s/",
			function()
				require("telescope.builtin").live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end,
			mode = { "n" },
			desc = "[S]earch [/] in Open Files",
		},
		{
			"<leader><leader>s",
			function()
				return require("telescope.builtin").buffers()
			end,
			mode = { "n" },
			desc = "[ ] Find existing buffers",
		},
		{
			"<leader>f.",
			function()
				return require("telescope.builtin").oldfiles()
			end,
			mode = { "n" },
			desc = '[S]earch Recent Files ("." for repeat)',
		},
		{
			"<leader>fr",
			function()
				return require("telescope.builtin").resume()
			end,
			mode = { "n" },
			desc = "[S]earch [R]esume",
		},
		{
			"<leader>fd",
			function()
				return require("telescope.builtin").diagnostics()
			end,
			mode = { "n" },
			desc = "[S]earch [D]iagnostics",
		},
		{
			"<leader>fg",
			function()
				return require("telescope.builtin").live_grep()
			end,
			mode = { "n" },
			desc = "[S]earch by [G]rep",
		},
		{
			"<leader>fw",
			function()
				return require("telescope.builtin").grep_string()
			end,
			mode = { "n" },
			desc = "[S]earch current [W]ord",
		},
		{
			"<leader>fs",
			function()
				return require("telescope.builtin").builtin()
			end,
			mode = { "n" },
			desc = "[S]earch [S]elect Telescope",
		},
		{
			"<leader>ff",
			function()
				return require("telescope.builtin").find_files()
			end,
			mode = { "n" },
			desc = "[S]earch [F]iles",
		},
		{
			"<C-p>",
			function()
				return require("telescope.builtin").find_files()
			end,
			mode = { "n" },
			desc = "[S]earch [F]iles",
		},
		{
			"<leader>fk",
			function()
				return require("telescope.builtin").keymaps()
			end,
			mode = { "n" },
			desc = "[S]earch [K]eymaps",
		},
		{
			"<leader>fh",
			function()
				return require("telescope.builtin").help_tags()
			end,
			mode = { "n" },
			desc = "[S]earch [H]elp",
		},
		{
			"<leader>gw",
			function()
				return require("telescope").extensions.git_worktree.git_worktree()
			end,
			mode = { "n" },
			desc = "Find [G]it [W]orktree",
		},
		{
			"<leader>gn",
			function()
				return require("telescope").extensions.git_worktree.create_git_worktree()
			end,
			mode = { "n" },
			desc = "[G]it [N]ew Branch",
		},
		{
			"<leader>pv",
			function()
				return require("telescope").extensions.file_browser.file_browser
			end,
			mode = { "n" },
			desc = "Open find browser",
		},
	},
	after = function()
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
					-- find_command = { "fd", "-H" },
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
			},
		})

		-- Enable telescope extensions, if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")
		pcall(require("telescope").load_extension, "git_worktree")
		pcall(require("telescope").load_extension, "package_info")
		pcall(require("telescope").load_extension, "live_grep_args")

		vim.api.nvim_create_user_command("LiveGrepGitRoot", live_grep_git_root, {})
	end,
}
