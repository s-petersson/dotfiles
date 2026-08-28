require('octo').setup({
    picker = 'telescope',

    -- Use the real files on disk for the review buffers so LSP, treesitter
    -- and go-to-definition attach while reviewing.
    use_local_fs = true,

    -- disable default mappings if true, but will still adapt user mappings
    mappings_disable_default = true,
    mappings = {
        runs = {
            expand_step = { lhs = 'o', desc = 'expand workflow step' },
            next_step = { lhs = ']s', desc = 'next workflow step' },
            prev_step = { lhs = '[s', desc = 'previous workflow step' },
            next_job = { lhs = ']j', desc = 'next workflow job' },
            prev_job = { lhs = '[j', desc = 'previous workflow job' },
            open_in_browser = { lhs = '<C-b>', desc = 'open workflow run in browser' },
            refresh = { lhs = '<C-r>', desc = 'refresh workflow' },
            rerun = { lhs = '<C-o>', desc = 'rerun workflow' },
            rerun_failed = { lhs = '<C-f>', desc = 'rerun failed workflow' },
            cancel = { lhs = '<C-x>', desc = 'cancel workflow' },
            copy_url = { lhs = '<C-y>', desc = 'copy url to system clipboard' },
        },
        pull_request = {
            list_commits = { lhs = '<localleader>pc', desc = 'list PR commits' },
            list_changed_files = { lhs = '<localleader>pf', desc = 'list PR changed files' },
            reload = { lhs = '<C-r>', desc = 'reload PR' },
            approve_pr = { lhs = '<leader>qa', desc = 'approve PR' },
            open_in_browser = { lhs = '<C-b>', desc = 'open PR in browser' },
            goto_file = { lhs = 'gf', desc = 'go to file' },
            add_comment = { lhs = '<localleader>ca', desc = 'add comment' },
            add_reply = { lhs = '<localleader>cr', desc = 'add reply' },
            delete_comment = { lhs = '<localleader>cd', desc = 'delete comment' },
            comment_edits = { lhs = '<localleader>ce', desc = 'show comment edit history' },
            next_comment = { lhs = ']C', desc = 'go to next comment' },
            prev_comment = { lhs = '[C', desc = 'go to previous comment' },
            review_start = { lhs = '<localleader>rs', desc = 'start a review for the current PR' },
            review_resume = {
                lhs = '<localleader>rr',
                desc = 'resume a pending review for the current PR',
            },
            resolve_thread = { lhs = '<localleader>rt', desc = 'resolve PR thread' },
            unresolve_thread = { lhs = '<localleader>rT', desc = 'unresolve PR thread' },
        },
        review_thread = {
            add_comment = { lhs = '<localleader>ca', desc = 'add comment' },
            add_reply = { lhs = '<localleader>cr', desc = 'add reply' },
            add_suggestion = { lhs = '<localleader>sa', desc = 'add suggestion' },
            delete_comment = { lhs = '<localleader>cd', desc = 'delete comment' },
            comment_edits = { lhs = '<localleader>ce', desc = 'show comment edit history' },
            next_comment = { lhs = ']C', desc = 'go to next comment' },
            prev_comment = { lhs = '[C', desc = 'go to previous comment' },
            select_next_entry = { lhs = '<Tab>', desc = 'move to next changed file' },
            select_prev_entry = { lhs = '<S-Tab>', desc = 'move to previous changed file' },
            resolve_thread = { lhs = '<localleader>rt', desc = 'resolve PR thread' },
            unresolve_thread = { lhs = '<localleader>rT', desc = 'unresolve PR thread' },
        },
        submit_win = {
            approve_review = { lhs = '<C-a>', desc = 'approve review', mode = { 'n' } },
            comment_review = { lhs = '<C-m>', desc = 'comment review', mode = { 'n' } },
            request_changes = { lhs = '<C-r>', desc = 'request changes review', mode = { 'n' } },
            close_review_tab = { lhs = '<C-c>', desc = 'close review tab', mode = { 'n' } },
        },
        review_diff = {
            submit_review = { lhs = '<localleader>rs', desc = 'submit review' },
            discard_review = { lhs = '<localleader>rd', desc = 'discard review' },
            add_review_comment = {
                lhs = '<localleader>ca',
                desc = 'add a new review comment',
                mode = { 'n', 'x' },
            },
            add_review_suggestion = {
                lhs = '<localleader>sa',
                desc = 'add a new review suggestion',
                mode = { 'n', 'x' },
            },
            focus_files = { lhs = '<localleader>e', desc = 'move focus to changed file panel' },
            toggle_files = { lhs = '<localleader>b', desc = 'hide/show changed files panel' },
            select_next_entry = { lhs = '<Tab>', desc = 'move to next changed file' },
            select_prev_entry = { lhs = '<S-Tab>', desc = 'move to previous changed file' },
            toggle_viewed = { lhs = '<localleader><space>', desc = 'toggle viewer viewed state' },
            goto_file = { lhs = 'gf', desc = 'go to file' },
            review_commits = { lhs = '<localleader>C', desc = 'review PR commits' },
        },
        file_panel = {
            submit_review = { lhs = '<localleader>rs', desc = 'submit review' },
            discard_review = { lhs = '<localleader>rd', desc = 'discard review' },
            next_entry = { lhs = 'j', desc = 'move to next changed file' },
            prev_entry = { lhs = 'k', desc = 'move to previous changed file' },
            select_entry = { lhs = '<cr>', desc = 'show selected changed file diffs' },
            refresh_files = { lhs = '<C-r>', desc = 'refresh changed files panel' },
            focus_files = { lhs = '<localleader>e', desc = 'move focus to changed file panel' },
            toggle_files = { lhs = '<localleader>b', desc = 'hide/show changed files panel' },
            select_next_entry = { lhs = '<Tab>', desc = 'move to next changed file' },
            select_prev_entry = { lhs = '<S-Tab>', desc = 'move to previous changed file' },
            toggle_viewed = { lhs = '<localleader><space>', desc = 'toggle viewer viewed state' },
            review_commits = { lhs = '<localleader>C', desc = 'review PR commits' },
        },
    },
    -- poll = {
    --     enabled = true, -- opt-in polling for remote changes
    --     interval = 60000, -- polling interval in milliseconds
    --     notify_on_refresh = true, -- notify when a buffer is auto-refreshed
    --     notify_on_change = true, -- notify when remote changed but buffer has local edits
    -- },
})
