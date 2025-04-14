-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Open Telescope when entering vim
vim.api.nvim_create_autocmd("VimEnter", {
	desc = "Open Telescope when entering vim",
	group = vim.api.nvim_create_augroup("kickstart-open-telescope", { clear = true }),
	callback = function()
		require("telescope.builtin").find_files()
	end,
})
