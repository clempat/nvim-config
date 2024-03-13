return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		-- import mason
		local mason = require("mason")

		-- import mason-lspconfig
		local mason_lspconfig = require("mason-lspconfig")

		local mason_tool_installer = require("mason-tool-installer")

		-- enable mason and configure icons
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			-- list of servers for mason to install
			ensure_installed = {
				"cssls",
				"emmet_ls",
				"graphql",
				"html",
				"lua_ls",
				"lua_ls",
				"omnisharp",
				"prismals",
				"pyright",
				"stylelint-lsp",
				"svelte",
				"tailwindcss",
				"terraformls",
				"tsserver",
			},
			-- auto-install configured servers (with lspconfig)
			automatic_installation = true, -- not the same as ensure_installed
		})

		mason_tool_installer.setup({
			ensure_installed = {
				"black", -- python formatter
				"eslint_d", -- js linter
				"isort", -- python formatter
				"node-debug2-adapter", -- node debugger
				"prettier", -- prettier formatter
				"pylint", -- python linter
				"stylelint", -- css linter
				"stylua", -- lua formatter
			},
		})
	end,
}
