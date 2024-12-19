local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({ { import = "clement.plugins" }, { import = "clement.plugins.lsp" } }, {
	install = {
		colorscheme = { "habamax" },
	},
	git = {
		throttle = {
			enabled = false,	
		},
	},
	checker = {
		enabled = true,
		notify = false,
		concurrency = 1
	},
	change_detection = {
		notify = false,
	},
})
