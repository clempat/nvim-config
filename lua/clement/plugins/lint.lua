return {
	"nvim-lint",
	for_cat = "general.lint",
	event = { "BufReadPre", "BufNewFile" },
	after = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescript = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			vue = { "eslint_d" },
			svelte = { "eslint_d" },
			python = { "ruff" },
			lua = { "luacheck" },
			sh = { "shellcheck" },
			yaml = { "yamllint" },
			nix = { "statix" },
			go = { "golangcilint" },
		}

		-- Lint on save and insert leave
		vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>ll", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })

		vim.keymap.set("n", "<leader>li", function()
			local ft = vim.bo.filetype
			local linters = lint.linters_by_ft[ft] or {}
			local lines = { "Filetype: " .. ft, "Linters: " .. (#linters > 0 and table.concat(linters, ", ") or "none") }
			-- Check if linter binaries exist
			for _, name in ipairs(linters) do
				local linter = lint.linters[name]
				local cmd = linter and linter.cmd or name
				local found = vim.fn.executable(cmd) == 1
				table.insert(lines, string.format("  %s: %s", name, found and "ok" or "NOT FOUND"))
			end
			vim.notify(table.concat(lines, "\n"), vim.log.levels.INFO)
		end, { desc = "Show active linters" })
	end,
}
