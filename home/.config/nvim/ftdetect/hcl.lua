vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
    pattern = '*.tf',
    command = 'set ft=hcl',
})
