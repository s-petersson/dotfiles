local CHARS = require('spetersson.utils.chars')

-- Diagnostic Config & Keymaps
-- See :help vim.diagnostic.Opts
vim.diagnostic.config({
    update_in_insert = false,
    severity_sort = true,
    float = { border = CHARS.border_chars_outer_thin, source = 'if_many' },

    underline = true,

    -- Can switch between these as you prefer
    virtual_text = true, -- Text shows up at the end of the line
    virtual_lines = false, -- Text shows up underneath the line, with virtual lines

    -- Auto open the float, so you can easily read the errors when jumping with `[d` and `]d`
    jump = { float = false },
})

-- Toggle diagnostics dynamically
vim.keymap.set('n', '<leader>tD', function()
    local old = vim.diagnostic.config()
    if old == nil or old.virtual_lines then
        vim.diagnostic.config({ virtual_lines = false })
    else
        vim.diagnostic.config({ virtual_lines = true })
    end
end)

vim.keymap.set('n', '<leader>td', function()
    local old = vim.diagnostic.config()
    if old == nil or old.virtual_text then
        vim.diagnostic.config({ virtual_text = false })
    else
        vim.diagnostic.config({ virtual_text = true })
    end
end)

vim.keymap.set('n', '<leader>tu', function()
    local old = vim.diagnostic.config()
    local modes = {
        { name = 'all', value = true }, -- needed for muted unused-code diagnostics
        {
            name = 'warnings + errors',
            value = { severity = { min = vim.diagnostic.severity.WARN } },
        },
        { name = 'errors only', value = { severity = { min = vim.diagnostic.severity.ERROR } } },
    }

    local underline = old and old.underline
    local current = 1
    if type(underline) == 'table' then
        local severity = underline.severity
        local min = type(severity) == 'table' and severity.min or severity
        if min == vim.diagnostic.severity.WARN then
            current = 2
        elseif min == vim.diagnostic.severity.ERROR then
            current = 3
        end
    end

    local next = modes[current + 1] or modes[1]
    vim.diagnostic.config({ underline = next.value })
    vim.notify('Diagnostic underlines: ' .. next.name)
end)
