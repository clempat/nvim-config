vim.opt.completeopt = { "menu", "menuone", "noselect" }

local status, cmp = pcall(require, "cmp")
if (not status) then return end

local ok, lspkind = pcall(require, "lspkind")
if not ok then return end

-- Don't show the dumb matching stuff.
vim.opt.shortmess:append "c"

lspkind.init {
	symbol_map = {
		Copilot = "",
	},
}
vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })


local mapping = {
	["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
	["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
	["<C-d>"] = cmp.mapping.scroll_docs(-4),
	["<C-f>"] = cmp.mapping.scroll_docs(4),
	["<C-e>"] = cmp.mapping.abort(),
	["<c-y>"] = cmp.mapping(
		cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		},
		{ "i", "c" }
	),
	["<M-y>"] = cmp.mapping(
		cmp.mapping.confirm {
			behavior = cmp.ConfirmBehavior.Replace,
			select = false,
		},
		{ "i", "c" }
	),
	["<c-space>"] = cmp.mapping {
		i = cmp.mapping.complete(),
		c = function(
			_ --[[fallback]]
		)
			if cmp.visible() then
				if not cmp.confirm { select = true } then
					return
				end
			else
				cmp.complete()
			end
		end,
	},
	-- ["<tab>"] = false,
	-- ["<tab>"] = cmp.config.disable,
}

local sources = {
	{ name = "nvim_lua" },
	{ name = "nvim_lsp" },
	{ name = "copilot" },
	{ name = "path" },
	{ name = 'buffer',  keyword_length = 5 },
}

cmp.setup({
	mapping = mapping,
	sources = sources,
	experimental = {
		native_menu = false,
	},
})
