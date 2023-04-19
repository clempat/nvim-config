-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'nvim-telescope/telescope-file-browser.nvim' -- file browser with telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- use {
    --     'svrana/neosolarized.nvim',
    --     requires = { 'tjdevries/colorbuddy.nvim' }
    -- }

    use({
        'rose-pine/neovim',
        as = 'rose-pine',
    })

    use({ 'nvim-treesitter/nvim-treesitter', { run = ':TSUpade' } })


    use 'jose-elias-alvarez/null-ls.nvim' -- Use Neovim as a language server to inject LSP diagnostics, code actions, and more via Lua

    use('nvim-treesitter/playground')

    use('theprimeagen/harpoon')

    use('mbbill/undotree')

    use('tpope/vim-fugitive')
    use('lewis6991/gitsigns.nvim')
    use('ThePrimeagen/git-worktree.nvim')

    use 'nvim-lualine/lualine.nvim' -- Fancier statusline
    use { 'numToStr/Comment.nvim',  -- "gc" to comment visual regions/lines
        requires = {
            'JoosepAlviste/nvim-ts-context-commentstring'
        }
    }
    use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

    -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

    use 'onsails/lspkind-nvim'         -- vscode-like pictograms

    use 'kyazdani42/nvim-web-devicons' -- File icons

    use 'windwp/nvim-autopairs'
    use 'windwp/nvim-ts-autotag'
    use 'norcalli/nvim-colorizer.lua'
    use 'folke/zen-mode.nvim'

    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },

            -- Useful status updates for LSP
            'j-hui/fidget.nvim',

            -- UI
            'glepnir/lspsaga.nvim'
        }
    }

    use 'wakatime/vim-wakatime'

    use {
        "folke/trouble.nvim",
        requires = "nvim-tree/nvim-web-devicons",
    }

    use "kdheepak/lazygit.nvim"

    use "github/copilot.vim"
end)
