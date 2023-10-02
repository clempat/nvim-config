vim.opt.completeopt = { "menu", "menuone", "noselect" }

local status, cmp = pcall(require, "cmp")
if not status then
	return
end

local ok, lspkind = pcall(require, "lspkind")
if not ok then
	return
end

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append("c")

lspkind.init({
	symbol_map = {
		Copilot = "",
	},
})
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })

cmp.setup({
	mapping = cmp.mapping.preset.insert({
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	}),
})

local sources = {
	{ name = "nvim_lua" },
	{ name = "nvim_lsp" },
	{ name = "copilot" },
	{ name = "path" },
	{ name = "buffer", keyword_length = 5 },
}

cmp.setup({
	mapping = mapping,
	sources = sources,
	experimental = {
		native_menu = false,
	},
})
