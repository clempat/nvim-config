local M = {}

-- overriding default plugin configs!
-- https://github.com/nvim-treesitter/nvim-treesitter#supported-languages
M.treesitter = {
	ensure_installed = {
		"bash",
		"c",
		"c_sharp",
		"css",
		"dockerfile",
		"html",
		"javascript",
		"json",
		"lua",
		"markdown",
    "rust",
		"toml",
		"typescript",
		"vim",
		"yaml",
    "nix",
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
		{ name = "buffer" },
		{ name = "cmp_tabnine" },
		{ name = "luasnip" },
		{ name = "nvim_lsp" },
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
