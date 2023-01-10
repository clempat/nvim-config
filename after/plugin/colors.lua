local rosepine = require("rose-pine")

rosepine.setup({
	disable_background = true,
	disable_float_background = true,
})

function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
	vim.api.nvim_set_hl(0, "NonText", { bg = "none", blend = 80 })

end

ColorMyPencils()
