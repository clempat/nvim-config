return {
	{
		"nvim-treesitter/nvim-treesitter",
		opts = function(_, opts)
			if type(opts.ensure_installed) == "table" then
				vim.list_extend(opts.ensure_installed, { "ninja", "python", "rst", "toml" })
			end
		end,
	},
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
		opts = {
			adapters = {
				["neotest-python"] = {
					-- Here you can specify the settings for the adapter, i.e.
					-- runner = "pytest",
					python = ".venv/bin/python",
				},
			},
		},
	},
	-- {
	-- 	"mfussenegger/nvim-dap",  -- Disabled: DAP not available in stable nixpkgs
	-- 	dependencies = {
	-- 		"mfussenegger/nvim-dap-python",
	-- 		"jay-babu/mason-nvim-dap.nvim",
      -- stylua: ignore
      -- keys = {
      --   { "<leader>dPt", function() require('dap-python').test_method() end, desc = "Debug Method", ft = "python" },
      --   { "<leader>dPc", function() require('dap-python').test_class() end, desc = "Debug Class", ft = "python" },
      -- },
	-- 		config = function()
	-- 			local path = require("mason-registry").get_package("debugpy"):get_install_path()
	-- 			require("dap-python").setup(path .. "/venv/bin/python")
	-- 		end,
	-- 	},
	-- },
	-- {
	-- 	"linux-cultist/venv-selector.nvim",
	-- 	dependencies = {
	-- 		"neovim/nvim-lspconfig",
	-- 		"mfussenegger/nvim-dap",
	-- 		"mfussenegger/nvim-dap-python", --optional
	-- 		{ "nvim-telescope/telescope.nvim", branch = "0.1.x", dependencies = { "nvim-lua/plenary.nvim" } },
	-- 	},
	-- 	lazy = false,
	-- 	branch = "regexp", -- This is the regexp branch, use this for the new version
	-- 	config = function()
	-- 		require("venv-selector").setup({
	-- 			auto_refresh = true,
	-- 		})
	-- 	end,
	-- 	keys = {
	-- 		{ ",v", "<cmd>VenvSelect<cr>" },
	-- 	},
	-- },
}
