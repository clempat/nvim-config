local status, lsp = pcall(require, "lsp-zero")
if (not status) then return end

lsp.preset("recommended")

lsp.ensure_installed({
    "cssls",
    "dockerls",
    "ember",
    "eslint",
    "golangci_lint_ls",
    "gopls",
    "html",
    "jdtls",
    "lua_ls",
    "omnisharp",
    "rnix",
    "rust_analyzer",
    "stylelint_lsp",
    "tailwindcss",
    "terraformls",
    "tsserver",
    "yamlls",
})

-- Special treatment for lua
lsp.configure('lua_ls', {
    force_setup = true,
    settings = {
        Lua = {
            diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
        },
    },
})

-- Don't care about yaml key ordering
lsp.configure("yamlls", {
    settings = {
        yaml = {
            keyOrdering = false
        }
    }
})

lsp.manage_nvim_cmp = false

vim.diagnostic.config({
    virtual_text = true,
})

lsp.on_attach(function(client, bufnr)
    if client.name == "copilot" then
        return
    end

    local opts = { buffer = bufnr, remap = false }

    -- format on save
    if client.server_capabilities.documentFormattingProvider then
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("Format", { clear = true }),
            buffer = bufnr,
            callback = function() vim.lsp.buf.format() end
        })
    end


    vim.keymap.set("n", "gD", function() vim.lsp.buf.definition() end, opts)
    -- vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
    vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>ca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>rr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>rn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.setup()
