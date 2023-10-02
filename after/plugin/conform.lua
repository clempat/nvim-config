local status, conform = pcall(require, "conform")
if (not status) then return end

conform.setup({
	formatters_by_ft = {
		lua = { 'stylua' },
		javascript = { { 'prettier', 'prettierd' } },
	},
	format_on_save = {
		lsp_fallback = true,
	}
})
