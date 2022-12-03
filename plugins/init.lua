local overrides = require("custom.plugins.configs.overrides")

return {
	["williamboman/mason-lspconfig.nvim"] = {
		after = "mason.nvim",
		config = function()
			require("mason-lspconfig").setup()
		end,
	},
	["neovim/nvim-lspconfig"] = {
		after = "mason-lspconfig.nvim",
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup()
			require("plugins.configs.lspconfig")
			require("custom.plugins.configs.lspconfig")
		end,
	},
	["nvim-telescope/telescope.nvim"] = {
		module = "telescope",
		override_options = overrides.telescope,
	},
	["windwp/nvim-ts-autotag"] = {
		ft = { "html", "javascriptreact" },
		after = "nvim-treesitter",
		config = function()
			require("nvim-ts-autotag").setup()
		end,
	},
	["jose-elias-alvarez/null-ls.nvim"] = {

		after = "nvim-lspconfig",
		config = function()
			require("custom.plugins.configs.null-ls").setup()
		end,
	},
	["nvim-telescope/telescope-media-files.nvim"] = {
		after = { "telescope.nvim" },

		config = function()
			require("telescope").load_extension("media_files")
		end,
	},
	["Pocco81/TrueZen.nvim"] = {

		cmd = {
			"TZAtaraxis",
			"TZMinimalist",
			"TZFocus",
		},
		config = function()
			require("custom.plugins.configs.truezen").setup()
		end,
	},
	["ThePrimeagen/harpoon"] = {
		after = { "plenary.nvim", "telescope.nvim" },
		config = function()
			require("telescope").load_extension("harpoon")
		end,
	},
	["tzachar/cmp-tabnine"] = {
		after = "nvim-cmp",
		run = "./install.sh",
		requires = "hrsh7th/nvim-cmp",
	},
	["tpope/vim-fugitive"] = {
		"vuki656/package-info.nvim",
		requires = "MunifTanjim/nui.nvim",
	},
	["folke/trouble.nvim"] = {

		requires = "kyazdani42/nvim-web-devicons",
		config = function()
			require("custom.plugins.configs.trouble").setup()
		end,
	},
	["andweeb/presence.nvim"] = {},
	["mfussenegger/nvim-dap"] = {
		config = function()
			require("custom.plugins.configs.dap").setup()
		end,
	},
	["rcarriga/nvim-dap-ui"] = {
		requires = "mfussenegger/nvim-dap",
		config = function()
			require("dapui").setup()
		end,
	},
	["microsoft/vscode-js-debug"] = {
		opt = true,
		run = "npm install --legacy-peer-deps && npm run compile",
	},
	["mxsdev/nvim-dap-vscode-js"] = {
		requires = { "mfussenegger/nvim-dap" },
		config = function()
			require("custom.plugins.configs.dap-vscode-js").setup()
		end,
	},
	["theHamsta/nvim-dap-virtual-text"] = {
		requires = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter" },
	},
	["nvim-telescope/telescope-dap.nvim"] = {
		requires = { "mfussenegger/nvim-dap", "nvim-treesitter/nvim-treesitter", "nvim-telescope/telescope.nvim" },
		before = { "telescope.nvim" },
	},
	["ThePrimeagen/git-worktree.nvim"] = {
		requires = { "nvim-telescope/telescope.nvim" },

		after = { "telescope.nvim" },

		config = function()
			require("git-worktree").setup()
			require("telescope").load_extension("git_worktree")
		end,
	},
	["ahmedkhalf/project.nvim"] = {
		after = { "telescope.nvim" },
		config = function()
			require("project_nvim").setup()
			require("telescope").load_extension("projects")
		end,
	},
	["nvim-treesitter/nvim-treesitter-context"] = {
		requires = "nvim-treesitter/nvim-treesitter",

		config = function()
			require("custom.plugins.configs.treesitter-context").setup()
		end,
	},

	-- Overrides
	["nvim-treesitter/nvim-treesitter"] = {
		override_options = overrides.treesitter,
	},
	["kyazdani42/nvim-tree.lua"] = {
		override_options = overrides.nvimtree,
	},
	["folke/which-key.nvim"] = {
		disable = false,
	},
	["hrsh7th/nvim-cmp"] = {
		override_options = overrides.cmp,
	},
}
