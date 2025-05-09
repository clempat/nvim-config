-- this is how to use the lsp handler.
require("lze").load({
	{
		"nvim-lspconfig",
		for_cat = "general.core",
		load = function(name)
			vim.cmd.packadd(name)
			vim.cmd.packadd("blink.cmp")
			vim.cmd.packadd("SchemaStore.nvim")
		end,
		-- define a function to run over all type(plugin.lsp) == table
		-- when their filetype trigger loads them
		lsp = function(plugin)
			-- in this case, just extend some default arguments with the ones provided in the lsp table
			require("lspconfig")[plugin.name].setup(vim.tbl_extend("force", {
				capabilities = require("clement.LSPs.caps-on_attach").get_capabilities(plugin.name),
				on_attach = require("clement.LSPs.caps-on_attach").on_attach,
			}, plugin.lsp or {}))
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
		"ts_ls",
		enabled = true,
		for_cat = "frontend",
		lsp = {
			filetypes = { "javascript", "typescript", "javascriptreact", "typescriptreact", "vue" },
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
		"pyright",
		for_cat = "python",
		filetypes = { "python" },
		lsp = {
			settings = {
				python = {
					analysis = {
						autoSearchPaths = true,
						useLibraryCodeForTypes = true,
						diagnosticMode = "workspace",
					},
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
