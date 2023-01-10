local status, n = pcall(require, "gitsigns")
if (not status) then return end

-- Gitsigns
-- See `:help gitsigns.txt`
n.setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}
