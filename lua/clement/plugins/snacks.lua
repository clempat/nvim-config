local function term_nav(dir)
	---@param self snacks.terminal
	return function(self)
		return self:is_floating() and "<c-" .. dir .. ">" or vim.schedule(function()
			vim.cmd.wincmd(dir)
		end)
	end
end

return {
	"snacks.nvim",
	for_cat = "general.extra",
	event = "DeferredUIEnter",
	after = function()
		require("snacks").setup({
			lazygit = {},
			input = {},
			terminal = {
				win = {
					keys = {
						nav_h = { "<C-h>", term_nav("h"), desc = "Go to Left Window", expr = true, mode = "t" },
						nav_j = { "<C-j>", term_nav("j"), desc = "Go to Lower Window", expr = true, mode = "t" },
						nav_k = { "<C-k>", term_nav("k"), desc = "Go to Upper Window", expr = true, mode = "t" },
						nav_l = { "<C-l>", term_nav("l"), desc = "Go to Right Window", expr = true, mode = "t" },
					},
				},
			},
		})
		vim.keymap.set("n", "<leader>gg", function()
			require("snacks").lazygit.open()
		end, { desc = "Snack Lazygit" })
		vim.keymap.set("n", "<leader-tt>", function()
			require("snacks").terminal.open()
		end, { desc = "Snack Lazygit" })
	end,
}
