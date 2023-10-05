local opt = vim.opt
opt.nu = true
opt.relativenumber = true

-- tab
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

opt.wrap = false

opt.swapfile = false
opt.backup = false
opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
opt.undofile = true

opt.hlsearch = false
opt.incsearch = true

opt.scrolloff = 8
opt.signcolumn = "yes"
opt.isfname:append("@-@")

opt.updatetime = 50

opt.colorcolumn = "80"

vim.g.mapleader = " "

opt.cursorline = false
opt.termguicolors = true
opt.winblend = 0
opt.wildoptions = "pum"
opt.pumblend = 30
opt.background = "dark"

opt.splitbelow = true

opt.timeoutlen = 500

