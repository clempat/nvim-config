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
lsp.configure('sumneko_lua', {
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

local cmp = require('cmp')
local lspkind = require('lspkind');
local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
})
local cmp_formatting = {
    format = lspkind.cmp_format({ with_text = false, maxwidth = 50 })
}

lsp.setup_nvim_cmp({
    mapping = cmp_mappings,
    formatting = cmp_formatting
})


vim.diagnostic.config({
    virtual_text = true,
})

lsp.on_attach(function(client, bufnr)
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
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

end)

lsp.setup()
