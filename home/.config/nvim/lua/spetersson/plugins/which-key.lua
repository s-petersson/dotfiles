require('which-key').setup({
    -- delay between pressing a key and opening which-key (milliseconds)
    delay = 750,
    icons = { mappings = vim.g.have_nerd_font },

    -- Document existing key chains
    spec = {
        { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
        { '<leader>t', group = '[T]oggle' },
        { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
        { '<leader>a', group = '[A]I', mode = { 'n', 'v' } },
        { 'gr', group = 'LSP Actions', mode = { 'n' } },
    },
})
