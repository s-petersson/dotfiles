local CHARS = require('spetersson.utils.chars')
require('oil').setup({
    float = {
        max_width = 0.65,
        max_height = 0.4,
        border = CHARS.border_chars_outer_thin,
    },
    keymaps = {
        ['q'] = 'actions.close',
    },
    view_options = {
        show_hidden = true,
    },
})

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'oil',
    callback = function(args)
        vim.opt_local.foldmethod = 'manual'
        pcall(function() require('gitsigns').detach(args.buf) end)
    end,
})
