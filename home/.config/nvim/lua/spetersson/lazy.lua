local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system({
        'git',
        'clone',
        '--filter=blob:none',
        '--branch=stable',
        'https://github.com/folke/lazy.nvim.git',
        lazypath,
    })
    if vim.v.shell_error ~= 0 then error('Error cloning lazy.nvim:\n' .. out) end
end

vim.opt.rtp:prepend(lazypath)

---@module 'lazy'
---@type LazySpec
local plugins = {
    -- Colortheme
    {
        'catppuccin/nvim',
        name = 'catppuccin',
        enabled = true,
        priority = 1000,
        config = function() require('spetersson.plugins.catppuccin') end,
    },
    -- Formatting
    {
        'stevearc/conform.nvim',
        event = { 'BufWritePre' },
        cmd = { 'ConformInfo' },
        config = function() require('spetersson.plugins.conform') end,
    },
    -- Completions
    {
        'saghen/blink.cmp',
        event = 'VimEnter',
        version = '1.*',
        dependencies = {
            'fang2hou/blink-copilot',
        },
        config = function() require('spetersson.plugins.blink-cmp') end,
    },
    -- Auto-insert pairs like (), {}, []
    {
        'windwp/nvim-autopairs',
        event = 'InsertEnter',
        config = function() require('nvim-autopairs').setup({}) end,
    },
    -- Copilot integration
    {
        'zbirenbaum/copilot.lua',
        cmd = 'Copilot',
        event = 'InsertEnter',
        dependencies = {
            -- Adds support for NES (Next Edit Suggestions)
            'copilotlsp-nvim/copilot-lsp',
        },
        config = function() require('spetersson.plugins.copilot') end,
    },
    -- File browser
    -- {
    --     'nvim-mini/mini.files',
    --     config = function() require('mini.files').setup({}) end,
    -- },
    {
        'stevearc/oil.nvim',
        dependencies = { { 'nvim-mini/mini.icons', opts = {} } },
        -- Lazy loading is not recommended because it is very tricky to make it work correctly in all situations.
        lazy = false,
        config = function() require('spetersson.plugins.oil') end,
    },
    -- Git signs in guttter
    {
        'lewis6991/gitsigns.nvim',
        config = function() require('spetersson.plugins.gitsigns') end,
    },
    -- Differ for git
    {
        'sindrets/diffview.nvim',
        cmd = { 'DiffviewOpen', 'DiffviewFileHistory' },
        config = function() require('spetersson.plugins.diffview') end,
    },
    -- Git inside vim
    {
        'tpope/vim-fugitive',
        cmd = {
            'Git',
            'Gdiffsplit',
            'Gread',
            'Gwrite',
            'Ggrep',
            'Gmove',
            'Gdelete',
            'Gblame',
        },
    },
    -- GitHub PRs/issues in Neovim
    {
        'pwntester/octo.nvim',
        cmd = 'Octo',
        dependencies = {
            'nvim-lua/plenary.nvim',
            'nvim-telescope/telescope.nvim',
        },
        config = function() require('spetersson.plugins.octo') end,
    },
    -- Auto find the indent level in current file
    {
        'NMAC427/guess-indent.nvim',
        opts = {},
    },
    -- Better experience when changing config
    {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        config = function() require('spetersson.plugins.lazydev') end,
    },
    -- Pretty markdown rendering
    -- {
    --     'MeanderingProgrammer/render-markdown.nvim',
    --     dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' },
    --     opts = {},
    -- },
    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        build = ':TSUpdate',
        branch = 'main',
        config = function() require('spetersson.plugins.nvim-treesitter') end,
    },
    -- Picker
    {
        'nvim-telescope/telescope.nvim',
        version = '*',
        dependencies = {
            'nvim-lua/plenary.nvim',
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
            'nvim-telescope/telescope-live-grep-args.nvim',
        },
        config = function() require('spetersson.plugins.telescope') end,
    },
    -- Collections of QoL stuff
    {
        'folke/snacks.nvim',
        priority = 1000,
        lazy = false,
        config = function() require('spetersson.plugins.snacks') end,
    },
    -- Render status lines above/below editors
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function() require('spetersson.plugins.lualine') end,
    },
    -- Neovim native LSP
    {
        -- Main LSP Configuration
        'neovim/nvim-lspconfig',
        dependencies = {
            -- Mason must be loaded before its dependents so we need to set it up here.
            { 'mason-org/mason.nvim', opts = {} },

            -- Maps LSP server names between nvim-lspconfig and Mason package names.
            'mason-org/mason-lspconfig.nvim',
            'WhoIsSethDaniel/mason-tool-installer.nvim',

            -- Useful status updates for LSP.
            { 'j-hui/fidget.nvim', opts = {} },
        },
        config = function() require('spetersson.plugins.nvim-lspconfig') end,
    },
    -- Typescript has a separate plugin, because the ts_ls language server is too slow for large projects
    -- (and I also think this separate plugin has better functionality)
    {
        'pmizio/typescript-tools.nvim',
        dependencies = { 'nvim-lua/plenary.nvim', 'neovim/nvim-lspconfig' },
        opts = {},
    },
    -- Pop a bottom panel showing what shortcuts are available after pressing a key
    {
        'folke/which-key.nvim',
        event = 'VimEnter',
        config = function() require('spetersson.plugins.which-key') end,
    },
    -- Highlight todo, notes, etc in comments
    {
        'folke/todo-comments.nvim',
        event = 'VimEnter',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function() require('spetersson.plugins.todo-comments') end,
    },
    -- Session management
    {
        'rmagatti/auto-session',
        lazy = false,
        config = function() require('spetersson.plugins.auto-session') end,
    },
    -- Centers the editors horizontally on demand
    {
        'shortcuts/no-neck-pain.nvim',
        commit = '434fed70b1ee553f8f27e6da7b3899f71b3c6f99',
        config = function() require('spetersson.plugins.no-neck-pain') end,
    },
    -- Better surround objects
    {
        'nvim-mini/mini.ai',
        opts = {},
    },
    -- Add/Change/Delete surrounding delimiter pairs, like {/"
    -- {
    --     'nvim-mini/mini.surround',
    --     opts = {},
    -- },
    {
        'tpope/vim-surround',
    },
    -- Better icons?
    {
        'echasnovski/mini.icons',
        opts = {},
        lazy = true,
        specs = {
            { 'nvim-tree/nvim-web-devicons', enabled = false, optional = true },
        },
        init = function() require('mini.icons').mock_nvim_web_devicons() end,
    },
    -- Auto close html/jsx tags
    {
        'windwp/nvim-ts-autotag',
        opts = {},
    },
    -- Teleportation!
    {
        'folke/flash.nvim',
        event = 'VeryLazy',
        opts = {},
    },
}

local opts = {
    ui = { border = 'rounded', backdrop = 100 },
}

require('lazy').setup(plugins, opts)
