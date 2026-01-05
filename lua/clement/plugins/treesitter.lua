return {
	{
		"nvim-treesitter",
		for_cat = "general.treesitter",
		-- cmd = { "" },
		event = "DeferredUIEnter",

		load = function(name)
			vim.cmd.packadd(name)
			vim.cmd.packadd("nvim-treesitter-context")
		end,
		after = function()
			-- Treesitter highlighting/indentation is automatic in Neovim 0.11+
			-- Just enable treesitter-context for showing current function/class
			require("treesitter-context").setup()
		end,
	},
}
