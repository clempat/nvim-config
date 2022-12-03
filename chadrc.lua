local M = {}

local plugin_conf = require("custom.plugins.configs")
local userPlugins = require("custom.plugins")

M.plugins = {
	status = {
		colorizer = true,
	},

	override = {
		["nvim-treesitter/nvim-treesitter"] = plugin_conf.treesitter,
		["kyazdani42/nvim-tree.lua"] = plugin_conf.nvimtree,
		["hrsh7th/nvim-cmp"] = plugin_conf.cmp,
		["telescope/telescope.nvim"] = plugin_conf.telescope,
	},

	user = userPlugins,
}

M.ui = {
	theme = "chadracula",
	theme_toggle = { "chadracula", "one_light" },
}

M.mappings = require("custom.mappings")

return M
