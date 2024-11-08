-- @TODO: Check why stylua is failing
return {
	"stevearc/conform.nvim",
	lazy = true,
	event = { "BufReadPre", "BufNewFile" }, -- to disable, comment this out
	config = function()
		local conform = require("conform")

		-- Default formatters configuration
		local default_formatters = {
			css = { "prettier" },
			htmldjango = { "djlint" },
			graphql = { "prettier" },
			html = { "prettier" },
			javascript = { "prettier" },
			javascriptreact = { "prettier" },
			json = { "prettier" },
			lua = { "stylua" },
			markdown = { "prettier" },
			nix = { "nixfmt-classic" },
			python = { "isort", "black" },
			sh = { "shfmt" },
			svelte = { "prettier" },
			sass = { "prettier" },
			typescript = { "prettier" },
			typescriptreact = { "prettier" },
			yaml = { "prettier" },
		}

		-- Try to load local config
		local local_config = {}
		local ok, config = pcall(require, ".nvim")
		if ok and config.conform and config.conform.formatters_by_ft then
			-- Merge local formatters with defaults
			local_config = vim.tbl_deep_extend("force", default_formatters, config.conform.formatters_by_ft)
		else
			local_config = default_formatters
		end

		conform.setup({
			formatters_by_ft = local_config,
			format_on_save = function(bufnr)
				-- Disable with a global or buffer-local variable
				if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
					return
				end
				-- Disable autoformat for files in a certain path
				local bufname = vim.api.nvim_buf_get_name(bufnr)
				if bufname:match("/node_modules/") then
					return
				end
				return {
					lsp_fallback = true,
					async = false,
					timeout_ms = 3000,
					quiet = false,
				}
			end,
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 1000,
			})
		end, { desc = "Format file or range (in visual mode)" })

		vim.api.nvim_create_user_command("FormatDisable", function(args)
			if args.bang then
				-- FormatDisable! will disable formatting just for this buffer
				vim.b.disable_autoformat = true
			else
				vim.g.disable_autoformat = true
			end
		end, {
			desc = "Disable autoformat-on-save",
			bang = true,
		})
		vim.api.nvim_create_user_command("FormatEnable", function()
			vim.b.disable_autoformat = false
			vim.g.disable_autoformat = false
		end, {
			desc = "Re-enable autoformat-on-save",
		})
	end,
}
