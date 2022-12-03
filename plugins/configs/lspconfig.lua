-- local lsp_installer = require("nvim-lsp-installer")
local lspconfig = require("lspconfig")
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

-- Include the servers you want to have installed by default below
-- https://github.com/williamboman/nvim-lsp-installer#available-lsps
local servers = {
	"cssls",
	"dockerls",
	"ember",
	"eslint",
	"golangci_lint_ls",
	"gopls",
	"graphql",
	"html",
	"jdtls",
	"omnisharp",
  "rnix",
	"stylelint_lsp",
	"tailwindcss",
	"terraformls",
	"tsserver",
	"yamlls",
}

for _, lsp in ipairs(servers) do
	lspconfig[lsp].setup({
		capabilities = capabilities,
		on_attach = function(client, bufnr)
			on_attach(client, bufnr)
			if lsp == "tsserver" then
				client.server_capabilities.document_formatting = false
				vim.api.nvim_buf_set_keymap(bufnr, "n", "<space>fm", "<cmd>lua vim.lsp.buf.format()<CR>", {})
			end
			if lsp == "stylelint_lsp" then
				client.server_capabilities.document_formatting = false
			end
		end,
	})
end
