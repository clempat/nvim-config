return {
  "zbirenbaum/copilot.lua",
  config = function()
    local copilot = require("copilot")
    copilot.setup({
      suggestion = {
        auto_trigger = true,
      },
      -- Node.js version must be > 16.x
      -- copilot_node_command = vim.fn.expand("$HOME") .. "/.nvm/versions/node/v18.18.0/bin/node", -- Node.js version must be > 16.x
    })
  end,
}
