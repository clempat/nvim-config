local has_tmux_nav, nvim_tmux_nav = pcall(require, "nvim-tmux-navigation")

vim.g.mapleader = " "
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) Using file browser with telescope
vim.keymap.set("i", "jk", "<Esc>")

vim.api.nvim_set_keymap("i", "<Tab>", 'pumvisible() ? "<C-y>" : "<Tab>"', { expr = true, noremap = true })

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", '"_dP')

-- next greatest remap ever : asbjornHaland
vim.keymap.set("n", "<leader>y", '"+y')
vim.keymap.set("v", "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+Y')

vim.keymap.set("n", "<leader>d", '"_d')
vim.keymap.set("v", "<leader>d", '"_d')

-- This is going to get me cancelled
vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format()
end)

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>")
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- lazygit
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<CR>")

-- whichkey
vim.keymap.set("n", "<silent> <leader>", "<cmd><c-u>WhichKey '<Space>'<CR>")
-- dap
vim.api.nvim_set_keymap("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<F10>", "<Cmd>lua require'dap'.step_over()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<F11>", "<Cmd>lua require'dap'.step_into()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<F12>", "<Cmd>lua require'dap'.step_out()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { silent = true })
vim.api.nvim_set_keymap(
	"n",
	"<Leader>B",
	"<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
	{ silent = true }
)
vim.api.nvim_set_keymap(
	"n",
	"<Leader>lp",
	"<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>",
	{ silent = true }
)
vim.api.nvim_set_keymap("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", { silent = true })
vim.api.nvim_set_keymap("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", { silent = true })

-- tmux navigation
if has_tmux_nav then
	vim.keymap.set("n", "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
	vim.keymap.set("n", "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
	vim.keymap.set("n", "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
	vim.keymap.set("n", "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
	vim.keymap.set("n", "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
	vim.keymap.set("n", "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
end

vim.keymap.set("t", "jk", "<C-\\><C-n>")
