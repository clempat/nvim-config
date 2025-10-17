local load_w_after = function(name)
	vim.cmd.packadd(name)
	vim.cmd.packadd(name .. "/after")
end

return {
	{
		"friendly-snippets",
		for_cat = "general.cmp",
		dep_of = { "blink.cmp" },
	},
	{
		"lspkind.nvim",
		for_cat = "general.cmp",
		dep_of = { "blink.cmp" },
		load = load_w_after,
	},
	{
		"luasnip",
		for_cat = "general.cmp",
		dep_of = { "blink.cmp" },
		after = function()
			local luasnip = require("luasnip")
			require("luasnip.loaders.from_vscode").lazy_load()
			luasnip.config.setup({})

			local ls = require("luasnip")

			vim.keymap.set({ "i", "s" }, "<M-n>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end)
		end,
	},
	{
		"blink.cmp",  -- Match the actual plugin directory name
		for_cat = "general.cmp",
		event = { "DeferredUIEnter" },
		load = function(name)
			-- Explicitly load the plugin
			vim.cmd.packadd(name)
		end,
		after = function()
			-- [[ Configure blink-cmp ]]
			-- See `:help cmp`
			local ok, cmp = pcall(require, "blink.cmp")
			if not ok then
				vim.notify("blink.cmp not available: " .. tostring(cmp), vim.log.levels.WARN)
				return
			end

			cmp.setup({
				-- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
				-- 'super-tab' for mappings similar to vscode (tab to accept)
				-- 'enter' for enter to accept
				-- 'none' for no mappings
				--
				-- All presets have the following mappings:
				-- C-space: Open menu or open docs if already open
				-- C-n/C-p or Up/Down: Select next/previous item
				-- C-e: Hide menu
				-- C-k: Toggle signature help (if signature.enabled = true)
				--
				-- See :h blink-cmp-config-keymap for defining your own keymap
				keymap = { preset = "default" },

				appearance = {
					-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
					-- Adjusts spacing to ensure icons are aligned
					nerd_font_variant = "mono",
				},

				-- (Default) Only show the documentation popup when manually triggered
				completion = {
					menu = {
						auto_show = function()
							return vim.bo.filetype ~= "copilot-chat"
						end,
						draw = {
							columns = {
								{ "label", "label_description", gap = 1 },
								{ "kind_icon", "kind", gap = 1 },
								{ "source_name" },
							},
							components = {
								kind_icon = {
									text = function(ctx)
										local icon = ctx.kind_icon
										if vim.tbl_contains({ "Path" }, ctx.source_name) then
											local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
											if dev_icon then
												icon = dev_icon
											end
										else
											icon = require("lspkind").symbolic(ctx.kind, {
												mode = "symbol",
											})
										end

										return icon .. ctx.icon_gap
									end,

									-- Optionally, use the highlight groups from nvim-web-devicons
									-- You can also add the same function for `kind.highlight` if you want to
									-- keep the highlight groups in sync with the icons.
									highlight = function(ctx)
										local hl = ctx.kind_hl
										if vim.tbl_contains({ "Path" }, ctx.source_name) then
											local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
											if dev_icon then
												hl = dev_hl
											end
										end
										return hl
									end,
								},
							},
						},
					},
				},

				-- Default list of enabled providers defined so that you can extend it
				-- elsewhere in your config, without redefining it, due to `opts_extend`
				sources = {
					default = { "lsp", "path", "snippets", "buffer" },
					per_filetype = {
						sql = { "snippets", "dadbod", "buffer" },
					},
					providers = {
						path = {
							enabled = function()
								return vim.bo.filetype ~= "copilot-chat"
							end,
						},
						dadbod = {
							name = "Dadbod",
							module = "vim_dadbod_completion.blink",
						},
					},
				},

				snippets = { preset = "luasnip" },

				-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
				-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
				-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
				--
				-- See the fuzzy documentation for more information
				fuzzy = { implementation = "prefer_rust_with_warning", sorts = { "exact", "score", "sort_text" } },
			})
		end,
	},
}
