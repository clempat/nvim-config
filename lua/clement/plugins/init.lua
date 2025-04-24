local colorschemeName = nixCats("colorscheme") or "onedark"

-- Could I lazy load on colorscheme with lze?
-- sure. But I was going to call vim.cmd.colorscheme() during startup anyway
-- this is just an example, feel free to do a better job!
vim.cmd.colorscheme(colorschemeName)

local ok, notify = pcall(require, "notify")
if ok then
	notify.setup({
		on_open = function(win)
			vim.api.nvim_win_set_config(win, { focusable = false })
		end,
	})
	vim.notify = notify
	vim.keymap.set("n", "<Esc>", function()
		notify.dismiss({ silent = true })
	end, { desc = "dismiss notify popup and clear hlsearch" })
end

if nixCats("general.extra") then
	require("oil").setup({
		default_files_explorer = true,
		delete_to_trash = true,
		skip_confirm_for_simple_edits = true,
		view_options = {
			show_hidden = true,
			natural_order = true,
			is_always_hidden = function(name)
				return name == ".." or name == ".git"
			end,
		},
		keymaps = {
			["g?"] = "actions.show_help",
			["<CR>"] = "actions.select",
			["<C-s>"] = "actions.select_vsplit",
			["<C-h>"] = "actions.select_split",
			["<C-t>"] = "actions.select_tab",
			["<C-p>"] = "actions.preview",
			["<C-c>"] = "actions.close",
			["<C-l>"] = "actions.refresh",
			["-"] = "actions.parent",
			["_"] = "actions.open_cwd",
			["`"] = "actions.cd",
			["~"] = "actions.tcd",
			["gs"] = "actions.change_sort",
			["gx"] = "actions.open_external",
			["g."] = "actions.toggle_hidden",
			["g\\"] = "actions.toggle_trash",
		},
		win_options = {
			signcolumn = "auto:2",
		},
	})
	vim.keymap.set("n", "-", "<cmd>Oil<CR>", { noremap = true, desc = "Open Parent Directory" })
	vim.keymap.set("n", "<leader>-", "<cmd>Oil .<CR>", { noremap = true, desc = "Open nvim root directory" })
end

require("lze").load({
	{
		"vim-wakatime",
		for_cat = "tracking",
		event = "DeferredUIEnter",
	}, -- time tracking
	{
		"vim-fugitive",
		for_cat = "general.always",
		event = "DeferredUIEnter",
	}, -- git integration
	{ "auto-pairs", event = "DeferredUIEnter", for_cat = "general.always" },
	{ "vista.vim", event = "DeferredUIEnter", for_cat = "general.extra" },
	{ import = "clement.plugins.telescope" },
	{ import = "clement.plugins.treesitter" },
	{ import = "clement.plugins.formatting" },
	{ import = "clement.plugins.completion" },
	{ import = "clement.plugins.ai" },
	{ import = "clement.plugins.lualine" },
	{ import = "clement.plugins.which-key" },
	{ import = "clement.plugins.database" },
	{ import = "clement.plugins.snacks" },
	{ import = "clement.plugins.gitlinker" },
	{ import = "clement.plugins.trouble" },
	{ import = "clement.plugins.noice" },
	{ import = "clement.plugins.mini" },
	{ import = "clement.plugins.gitsigns" },
})
