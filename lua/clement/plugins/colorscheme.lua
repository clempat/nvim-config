return {
	"rose-pine/neovim",
	name = "rose-pine",
	priority = 1000, -- make sure to load this before all the other start plugins
	config = function()
		local rp = require("rose-pine")
		rp.setup({
			disable_background = true,
			disable_float_background = false,
		})

		-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		-- vim.api.nvim_set_hl(0, "NonText", { bg = "none", blend = 80 })

		-- load the colorscheme here
		vim.cmd([[colorscheme rose-pine]])
	end,
}