local telescope = require('telescope')
local actions = require('telescope.actions')
local lga_actions = require('telescope-live-grep-args.actions')

telescope.setup({
    defaults = {
        sorting_strategy = 'ascending',
        layout_config = {
            prompt_position = 'top',
        },
        file_ignore_patterns = {
            '^%.git/',
        },
        mappings = {
            i = {
                ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
            n = {
                ['<C-q>'] = actions.send_selected_to_qflist + actions.open_qflist,
            },
        },
    },
    pickers = {
        find_files = {
            hidden = true,
        },
    },
    extensions = {
        live_grep_args = {
            additional_args = { '--hidden' },
            auto_quoting = true, -- enable/disable auto-quoting
            -- define mappings, e.g.
            mappings = { -- extend mappings
                i = {
                    ['<C-k>'] = lga_actions.quote_prompt(),
                    ['<C-g>'] = lga_actions.quote_prompt({ postfix = ' --iglob ' }),
                },
            },
        },
    },
})

telescope.load_extension('live_grep_args')
