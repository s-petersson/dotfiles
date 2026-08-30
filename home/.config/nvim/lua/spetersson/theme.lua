local M = {}

function M.reload()
    if not require('spetersson.utils.colors').reload() then return end

    package.loaded['spetersson.plugins.catppuccin'] = nil
    require('spetersson.plugins.catppuccin')

    package.loaded['lualine.themes.auto'] = nil
    package.loaded['spetersson.plugins.lualine'] = nil
    require('spetersson.plugins.lualine')
    require('lualine').refresh({ scope = 'all', force = true })
    vim.cmd('redrawstatus!')
end

function M.setup()
    vim.api.nvim_create_user_command('DotfilesThemeReload', M.reload, {})
    vim.api.nvim_create_autocmd('Signal', {
        pattern = 'SIGUSR1',
        callback = M.reload,
    })
end

return M
