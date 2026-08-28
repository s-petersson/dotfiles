vim.api.nvim_create_user_command('GitTodos', function(opts)
    local commit = opts.args
    local efm = vim.o.errorformat
    vim.o.errorformat = '%*[^:]:%f:%l:%m'
    local cmd = string.format('git diff-tree --no-commit-id --name-only -r %s | xargs git grep -n "# TODO" %s --', commit, commit)
    vim.fn.setqflist({}, ' ', { lines = vim.fn.systemlist(cmd) })
    vim.o.errorformat = efm
    vim.cmd 'copen'
end, { nargs = 1 })
