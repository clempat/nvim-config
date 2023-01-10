local status, n = pcall(require, "fidget")
if (not status) then return end
-- Turn on lsp status information
n.setup()
