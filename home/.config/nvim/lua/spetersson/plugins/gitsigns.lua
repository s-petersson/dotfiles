local CHARS = require('spetersson.utils.chars')

require('gitsigns').setup({
    signs = {
        add = { text = CHARS.left_thick },
        change = { text = CHARS.left_thick },
        delete = { text = CHARS.left_thick },
        topdelete = { text = CHARS.left_thick },
        changedelete = { text = CHARS.left_thick },
        untracked = { text = CHARS.left_thick },
    },
    signs_staged = {
        add = { text = CHARS.left_thick },
        change = { text = CHARS.left_thick },
        delete = { text = CHARS.left_thick },
        topdelete = { text = CHARS.left_thick },
        changedelete = { text = CHARS.left_thick },
        untracked = { text = CHARS.left_thick },
    },
    attach_to_untracked = true,
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 250,
    },
    on_attach = function(bufnr) require('spetersson.keymaps').gitsigns(bufnr) end,
})
