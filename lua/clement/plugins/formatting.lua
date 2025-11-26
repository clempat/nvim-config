return {
	"conform.nvim",
	for_cat = "general.format",
	event = "DeferredUIEnter",
	after = function()
		local conform = require("conform")

		local default_config = {
			formatters_by_ft = {
				css = { "prettierd" },
				htmldjango = { "djlint" },
				graphql = { "prettierd" },
				html = { "prettierd" },
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				json = { "prettierd" },
				lua = { "stylua" },
				markdown = { "prettierd" },
				nix = { "nixfmt" },
				python = { "ruff_organize_imports", "ruff_format" },
				sh = { "shfmt" },
				svelte = { "prettierd" },
				sass = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				vue = { "prettierd" },
				yaml = { "prettierd" },
				go = { "gofumpt" },
				-- gotmpl has no reliable formatter, use LSP or manual
			},

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
					lsp_format = "fallback",
					async = false,
					timeout_ms = 3000,
					quiet = false,
				}
			end,
		}

		-- Try to load local config
		local config_path = vim.fn.findfile(".nvim.lua", vim.fn.getcwd() .. ";")

		if config_path ~= "" then
			local ok, local_config = pcall(dofile, config_path)
			if ok and local_config and local_config.conform then
				-- Deep merge all conform options, but warn about eslint_d
				if local_config.conform.formatters_by_ft then
					for ft, formatters in pairs(local_config.conform.formatters_by_ft) do
						if vim.tbl_contains(formatters, "eslint_d") then
							vim.notify(
								string.format("Warning: eslint_d formatter configured for %s but not available", ft),
								vim.log.levels.WARN
							)
						end
					end
				end
				default_config = vim.tbl_deep_extend("force", default_config, local_config.conform)
			elseif not ok then
				vim.notify("Failed to load .nvim.lua: " .. tostring(local_config), vim.log.levels.ERROR)
			end
		end

		conform.setup(default_config)

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			conform.format({
				lsp_format = "fallback",
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
