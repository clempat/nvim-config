local null_ls = require("null-ls")
local b = null_ls.builtins

local sources = {

	b.diagnostics.eslint_d,
	b.formatting.prettierd.with({
		filetypes = {
			"html",
			"markdown",
			"css",
			"typescriptreact",
			"javascript",
			"typescript",
			"javascriptreact",
			"typescript.tsx",
			"javascript.jsx",
		},
	}),
	-- b.formatting.deno_fmt,

	-- Lua
	b.formatting.stylua,
	b.diagnostics.luacheck.with({ args = { "--globals vim" } }),

	-- Shell
	b.formatting.shfmt,
	b.diagnostics.shellcheck.with({ diagnostics_format = "#{m} [#{c}]" }),
}

local M = {}

M.setup = function()
	null_ls.setup({
		sources = sources,

		-- format on save
		on_attach = function(client)
			if client.resolved_capabilities.document_formatting then
				vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()")
			end
		end,
	})
end

return M
