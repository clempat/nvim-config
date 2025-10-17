-- NOTE: This file uses lzextras.lsp handler https://github.com/BirdeeHub/lzextras?tab=readme-ov-file#lsp-handler
-- This is a slightly more performant fallback function
-- for when you don't provide a filetype to trigger on yourself.
-- nixCats gives us the paths, which is faster than searching the rtp!
local lze = require("lze")
local old_ft_fallback = lze.h and lze.h.lsp and lze.h.lsp.get_ft_fallback() or function() return {} end
if lze.h and lze.h.lsp and lze.h.lsp.set_ft_fallback then
	lze.h.lsp.set_ft_fallback(function(name)
	local lspcfg = nixCats.pawsible({ "allPlugins", "opt", "nvim-lspconfig" })
		or nixCats.pawsible({ "allPlugins", "start", "nvim-lspconfig" })
	if lspcfg then
		local ok, cfg = pcall(dofile, lspcfg .. "/lsp/" .. name .. ".lua")
		if not ok then
			ok, cfg = pcall(dofile, lspcfg .. "/lua/lspconfig/configs/" .. name .. ".lua")
		end
		return (ok and cfg or {}).filetypes or {}
	else
		return old_ft_fallback(name)
	end
	end)
end -- this is how to use the lsp handler.

require("lze").load({
	{
		"nvim-lspconfig",
		for_cat = "general.core",
		-- NOTE: define a function for lsp,
		-- and it will run for all specs with type(plugin.lsp) == table
		-- when their filetype trigger loads them
		lsp = function(plugin)
			-- Use new vim.lsp.config API for Neovim 0.11+
			local config = plugin.lsp or {}
			-- Add default on_attach if not provided
			if not config.on_attach then
				config.on_attach = require("clement.LSPs.on-attach")
			end
			-- Add blink.cmp capabilities if available
			local ok, blink = pcall(require, "blink.cmp")
			if ok then
				config.capabilities = blink.get_lsp_capabilities(config.capabilities)
			end
			vim.lsp.config(plugin.name, config)
		end,
		before = function(_)
			-- Setup default on_attach for all LSPs
			-- This is handled per-LSP in the lsp function above
		end,
	},
	{
		-- lazydev makes your lsp way better in your config without needing extra lsp configuration.
		"lazydev.nvim",
		for_cat = "neonixdev",
		cmd = { "LazyDev" },
		ft = "lua",
		after = function(_)
			require("lazydev").setup({
				library = {
					{ words = { "nixCats" }, path = (nixCats.nixCatsPath or "") .. "/lua" },
				},
			})
		end,
	},
	{
		"terraformls",
		for_cat = "infrastructure",
		filetypes = { "terraform", "tf" },
		lsp = {
			settings = {
				terraform = {
					format = { enable = true },
					validate = true,
					completion = { enable = true },
				},
			},
		},
	},
	{
		-- name of the lsp
		"lua_ls",
		enabled = nixCats("lua") or nixCats("neonixdev") or false,
		-- provide a table containing filetypes,
		-- and then whatever your functions defined in the function type specs expect.
		-- in our case, it just expects the normal lspconfig setup options,
		-- but with a default on_attach and capabilities
		lsp = {
			-- if you provide the filetypes it doesn't ask lspconfig for the filetypes
			filetypes = { "lua" },
			settings = {
				Lua = {
					runtime = { version = "LuaJIT" },
					formatters = {
						ignoreComments = true,
					},
					signatureHelp = { enabled = true },
					diagnostics = {
						globals = { "nixCats", "vim" },
						disable = { "missing-fields" },
					},
					telemetry = { enabled = false },
				},
			},
		},
		-- also these are regular specs and you can use before and after and all the other normal fields
	},
	{
		"vtsls",
		enabled = true,
		for_cat = "frontend",
		lsp = {
			filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
			settings = {
				typescript = {
					inlayHints = {
						parameterNames = { enabled = "all" },
						parameterTypes = { enabled = true },
						variableTypes = { enabled = true },
						propertyDeclarationTypes = { enabled = true },
						functionLikeReturnTypes = { enabled = true },
						enumMemberValues = { enabled = true },
					},
				},
			},
		},
	},

	{
		"jsonls",
		enabled = true,
		filetypes = { "json", "jsonc" },
		lsp = {
			settings = {
				json = {
					format = { enable = true },
					-- TODO: fixme
					-- schemas = require("schemastore").json.schemas(),
				},
			},
		},
	},
	{
		"tailwindcss",
		for_cat = "frontend",
		lsp = {
			filetypes = {
				"html",
				"css",
				"javascript",
				"typescript",
				"javascriptreact",
				"typescriptreact",
				"astro",
				"vue",
			},
			settings = {
				tailwindcss = {
					lint = { cssConflict = "ignore" },
					validate = true,
				},
			},
		},
	},
	{
		"yamlls",
		enabled = true,
		load = function(name)
			vim.cmd.packadd(name)
			vim.cmd.packadd("SchemaStore.nvim")
		end,
		filetypes = { "yaml" },
		lsp = {
			settings = {
				yaml = {
					format = { enable = true },
					-- TODO: fixme
					-- schemas = require("schemastore").json.schemas(),
				},
			},
		},
	},
	{
		"ty",
		for_cat = "python",
		filetypes = { "python" },
		lsp = {
			settings = {
				ty = {
					cmd = { "ty", "server" },
					root_markers = { "ty.toml", "pyproject.toml", ".git" },
				},
			},
		},
	},
	{
		"ruff",
		for_cat = "python",
		filetypes = { "python" },
		lsp = {
			settings = {
				ruff = {
					args = { "--fix" }, -- Automatically fix issues if possible
				},
			},
		},
	},


	{
		"astro",
		for_cat = "frontend",
		filetypes = { "astro" },
		lsp = {
			settings = {
				astro = {
					format = { enable = true },
					lint = { enable = true },
				},
			},
		},
	},
	{
		"nixd",
		enabled = true,
		lsp = {
			filetypes = { "nix" },
			settings = {
				nixd = {
					-- nixd requires some configuration.
					-- luckily, the nixCats plugin is here to pass whatever we need!
					-- we passed this in via the `extra` table in our packageDefinitions
					-- for additional configuration options, refer to:
					-- https://github.com/nix-community/nixd/blob/main/nixd/docs/configuration.md
					nixpkgs = {
						-- in the extras set of your package definition:
						-- nixdExtras.nixpkgs = ''import ${pkgs.path} {}''
						expr = nixCats.extra("nixdExtras.nixpkgs") or [[import <nixpkgs> {}]],
					},
					options = {
						-- If you integrated with your system flake,
						-- you should use inputs.self as the path to your system flake
						-- that way it will ALWAYS work, regardless
						-- of where your config actually was.
						nixos = {
							-- nixdExtras.nixos_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").nixosConfigurations.configname.options''
							expr = nixCats.extra("nixdExtras.nixos_options"),
						},
						-- If you have your config as a separate flake, inputs.self would be referring to the wrong flake.
						-- You can override the correct one into your package definition on import in your main configuration,
						-- or just put an absolute path to where it usually is and accept the impurity.
						["home-manager"] = {
							-- nixdExtras.home_manager_options = ''(builtins.getFlake "path:${builtins.toString inputs.self.outPath}").homeConfigurations.configname.options''
							expr = nixCats.extra("nixdExtras.home_manager_options"),
						},
					},
					formatting = {
						command = { "nixfmt" },
					},
					diagnostic = {
						suppress = {
							"sema-escaping-with",
						},
					},
				},
			},
		},
	},
})


