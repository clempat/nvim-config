return {
	"diffview.nvim",
	for_cat = "general.extra",
	cmd = { "DiffviewOpen", "DiffviewFileHistory", "DiffviewClose" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Diffview open" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory %<cr>", desc = "File history" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory<cr>", desc = "Repo history" },
		{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Diffview close" },
	},
	after = function()
		require("diffview").setup()
	end,
}
