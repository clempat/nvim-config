return {
	"gitsigns.nvim",
	enabled = true,
	event = "DeferredUIEnter",
	after = function()
		require("gitsigns").setup({})
	end,
}
