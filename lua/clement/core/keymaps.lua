vim.g.mapleader = " "

local keymap = vim.keymap

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" })
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" })

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" })
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" })
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" })
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" })
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" })

-- AI / CodeCompanion
keymap.set({ "n", "v" }, "<leader>ca", "<cmd>CodeCompanionChat litellm<CR>", { desc = "[c]ode: codecompanion ch[a]t" })
keymap.set({ "n", "v" }, "<leader>cc", "<cmd>CodeCompanionActions<CR>", { desc = "[c]ode: [c]odecompanion actions" })
keymap.set("n", "<leader>ct", "<cmd>CodeCompanionChat litellm Toggle<CR>", { desc = "[c]ode: codecompanion [t]oggle" })
keymap.set("n", "<leader>ci", "<cmd>CodeCompanion<CR>", { desc = "[c]ode: codecompanion [i]nline" })

-- AI / Avante (commented - switch to compare)
-- keymap.set({ "n", "v" }, "<leader>ca", "<cmd>AvanteAsk<CR>", { desc = "[c]ode: [a]vante ask" })
-- keymap.set("n", "<leader>cc", "<cmd>AvanteChat<CR>", { desc = "[c]ode: avante [c]hat" })
-- keymap.set("n", "<leader>cz", "<cmd>AvanteZen<CR>", { desc = "[c]ode: avante [z]en mode" })

-- Diagnostics: toggle virtual lines vs virtual text
local diagnostic_virtual_lines = false
keymap.set("n", "<leader>uD", function()
	diagnostic_virtual_lines = not diagnostic_virtual_lines
	vim.diagnostic.config({
		virtual_text = not diagnostic_virtual_lines,
		virtual_lines = diagnostic_virtual_lines,
	})
	vim.notify("Diagnostic virtual lines: " .. (diagnostic_virtual_lines and "ON" or "OFF"))
end, { desc = "Toggle diagnostic virtual lines" })
