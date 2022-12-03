local M = {}

-- overriding default plugin configs!
M.treesitter = {
	ensure_installed = {
		"typescript",
		"lua",
		"vim",
		"html",
		"css",
		"javascript",
		"json",
		"toml",
		"markdown",
		"c",
		"bash",
		"dockerfile",
		"yaml",
	},
}

M.nvimtree = {
	git = {
		enable = true,
	},
	view = {
		side = "right",
		width = 60,
	},
}

M.cmp = {
	sources = {
		{ name = "nvim_lsp" },
		{ name = "cmp_tabnine" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "nvim_lua" },
		{ name = "path" },
	},
}

M.telescope = {
	extensions = {
		media_files = {
			filetypes = { "png", "webp", "jpg", "jpeg", "svg" },
		},
		-- fd is needed
	},
}

return M
