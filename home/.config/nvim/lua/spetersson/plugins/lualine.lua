local CHARS = require('spetersson.utils.chars')
local COLORS = require('spetersson.utils.colors')

local theme = require('lualine.themes.auto')

theme.normal.a.bg = COLORS.mocha.surface0
theme.normal.a.fg = COLORS.mocha.blue

theme.insert.a.bg = COLORS.mocha.surface0
theme.insert.a.fg = COLORS.mocha.green

theme.visual.a.bg = COLORS.mocha.surface0
theme.visual.a.fg = COLORS.mocha.pink

require('lualine').setup({
    options = {
        globalstatus = true,
        component_separators = '',
        section_separators = '',
        theme = theme,
    },
    sections = {
        lualine_a = {
            {
                function() return CHARS.left_very_thick end,
                color = function()
                    local mode_colors = {
                        n = COLORS.mocha.blue,
                        i = COLORS.mocha.green,
                        v = COLORS.mocha.pink,
                        V = COLORS.mocha.pink,
                        ['\22'] = COLORS.mocha.pink,
                    }
                    local fg = mode_colors[vim.fn.mode()] or COLORS.mocha.blue
                    return { fg = fg, bg = COLORS.mocha.surface0 }
                end,
                padding = 0,
                separator = { left = '', right = '' },
            },
            { 'mode' },
        },
        lualine_b = {},
        lualine_c = {
            {
                function() return ' ' end,
                padding = { left = 1, right = 0 },
                color = { fg = COLORS.mocha.overlay0 },
            },
            {
                'filename',
                file_status = true,
                newfile_status = true,
                path = 4,
                padding = { left = 1, right = 1 },
            },
            {
                function() return ' ' end,
                padding = { left = 1, right = 0 },
                color = { fg = COLORS.mocha.overlay0 },
            },
            {
                'branch',
                icons_enabled = false,
                padding = { left = 1, right = 1 },
            },
        },
        lualine_x = {
            -- 'fileformat',
            {
                function() return ' ' end,
                padding = { left = 1, right = 0 },
                color = { fg = COLORS.mocha.overlay0 },
            },
            {
                'filetype',
                color = { fg = COLORS.mocha.overlay0 },
                icons_enabled = false,
            },
            {
                'diagnostics',
                symbols = {
                    error = CHARS.diagnostic_signs.error .. ' ',
                    warn = CHARS.diagnostic_signs.warn .. ' ',
                    info = CHARS.diagnostic_signs.info .. ' ',
                    hint = CHARS.diagnostic_signs.hint .. ' ',
                },
            },
            { 'selectioncount' },
            { 'searchcount' },
        },
        lualine_y = {},
        lualine_z = {
            {
                'location',
                color = { fg = COLORS.mocha.text },
                fmt = function(str) return '  ' .. str end,
                padding = 1,
            },
            {
                'progress',
                color = { fg = COLORS.mocha.text },
                fmt = function(str) return '  ' .. str end,
                padding = 1,
            },
            {
                function() return CHARS.right_very_thick end,
                color = { fg = COLORS.mocha.blue, bg = COLORS.mocha.surface0 },
                padding = 0,
                separator = { left = '', right = '' },
            },
        },
    },
    -- winbar = {
    --     lualine_c = {
    --         {
    --             function()
    --                 local filepath = vim.fn.expand '%:~:.:h' -- relative directory path
    --                 if filepath == '.' then return '' end
    --                 return filepath:gsub('/', ' › ') .. ' › '
    --             end,
    --             color = 'WinBarPath',
    --             padding = { left = 1, right = 0 },
    --         },
    --         { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 }, color = 'WinBarFilename' },
    --         {
    --             function()
    --                 return vim.fn.expand '%:t' -- filename without extension
    --             end,
    --             color = 'WinBarFilename',
    --             padding = { left = 0, right = 0 },
    --         },
    --     },
    -- },
    -- inactive_winbar = {
    --     lualine_c = {
    --         {
    --             function()
    --                 local filepath = vim.fn.expand '%:~:.:h' -- relative directory path
    --                 if filepath == '.' then return '' end
    --                 return filepath:gsub('/', ' › ') .. ' › '
    --             end,
    --             color = 'WinBarPath',
    --             padding = { left = 1, right = 0 },
    --         },
    --         { 'filetype', icon_only = true, separator = '', padding = { left = 1, right = 0 }, color = 'WinBarFilename' },
    --         {
    --             function()
    --                 return vim.fn.expand '%:t' -- filename without extension
    --             end,
    --             color = 'WinBarFilename',
    --             padding = { left = 0, right = 0 },
    --         },
    --     },
    -- },
})
