local CHARS = require('spetersson.utils.chars')
local map = vim.keymap.set

local M = {}

function M.init()
    M.misc()
    M.conform()
    M.diffview()
    M.octo()
    M.fugitive()
    M.telescope()
    M.noneckpain()
    M.flash()
    M.oil()
end
-- Keep the cursor in place when using J
map('n', 'J', 'mzJ`z')

-- Keep the cursor in the middle of the screen when jumping
map('n', '<C-d>', '<C-d>zz')
map('n', '<C-u>', '<C-u>zz')

-- Keep search terms in the middle of the screen when going through them
map('n', 'n', 'nzzzv')
map('n', 'N', 'Nzzzv')

-- ThePrimeagen quote: "Don't ever press Q, honestly, it's the worst place in the universe"
map('n', 'Q', '<nop>')

-- Clear highlights on search when pressing <Esc> in normal mode
map('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Quickfix next/prev
map('n', '[q', '<cmd>cprev<CR>')
map('n', ']q', '<cmd>cnext<CR>')

-- Dont deselect the visual selection when indenting or de-indenting
map('v', '<', '<gv', {})
map('v', '>', '>gv', {})

-- Allow moving highlighted lines in visual mode
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
-- C-h/j/k/l navigation handled by navigator (see lua/navigator.lua)

map('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- map('n', '<leader>e', function()
--     local path = vim.api.nvim_buf_get_name(0)
--     if path ~= '' and vim.fn.filereadable(path) == 1 then
--         require('mini.files').open(vim.fn.fnamemodify(path, ':h'))
--     else
--         require('mini.files').open()
--     end
-- end, { desc = 'Open MiniFiles' })
--
-- map(
--     'n',
--     '<leader>E',
--     function() require('mini.files').open() end,
--     { desc = 'Open MiniFiles (default)' }
-- )

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
map('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Resize splits with the same directional keys used by Herdr.
map('n', '<C-S-h>', '<cmd>vertical resize -2<CR>', { desc = 'Shrink split width' })
map('n', '<C-S-j>', '<cmd>resize +2<CR>', { desc = 'Grow split height' })
map('n', '<C-S-k>', '<cmd>resize -2<CR>', { desc = 'Shrink split height' })
map('n', '<C-S-l>', '<cmd>vertical resize +2<CR>', { desc = 'Grow split width' })

-- Window management
-- map('n', '<leader>wq', '<C-w>q', { desc = 'Close window' })
-- map('n', '<leader>wv', '<C-w>v', { desc = 'Split window vertically' })
-- map('n', '<leader>wh', '<C-w>s', { desc = 'Split window horizontally' })
-- map('n', '<leader>wH', '<C-w>H', { desc = 'Swap window left' })
-- map('n', '<leader>wL', '<C-w>L', { desc = 'Swap window right' })
-- map('n', '<leader>wJ', '<C-w>J', { desc = 'Swap window down' })
-- map('n', '<leader>wK', '<C-w>K', { desc = 'Swap window up' })

-- Tab navigation
map('n', '[t', '<cmd>tabprevious<CR>', { desc = 'Previous tab' })
map('n', ']t', '<cmd>tabnext<CR>', { desc = 'Next tab' })
map('n', '<leader>tq', '<cmd>tabclose<CR>', { desc = 'Close tab' })

function M.misc()
    -- Strip trailing whitespace
    map('n', '<leader>sw', function()
        local view = vim.fn.winsaveview()
        vim.cmd([[%s/\s\+$//e]])
        vim.fn.winrestview(view)
    end, { desc = '[F]ormat: strip trailing [w]hitespace' })
end

function M.conform()
    map(
        'n',
        '<leader>fm',
        function() require('conform').format({ async = true, lsp_format = 'fallback' }) end,
        { desc = '[F]or[m]at buffer' }
    )
end

function M.diffview()
    map('n', '<leader>gd', '<cmd>DiffviewOpen develop<cr>', { desc = 'Diff against develop' })
    map('n', '<leader>gD', ':DiffviewOpen ', { desc = 'Diff against...' })
    map('n', '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', { desc = 'File history' })
    map('n', '<leader>gH', '<cmd>DiffviewFileHistory<cr>', { desc = 'Branch history' })
    map('n', '<leader>gq', '<cmd>DiffviewClose<cr>', { desc = 'Close diff view' })
end

function M.octo()
    map('n', '<leader>go', '<cmd>Octo pr list<cr>', { desc = 'PR list' })
    map('n', '<leader>gp', ':Octo pr ', { desc = 'PR by number...' })
    map('n', '<leader>gr', '<cmd>Octo review start<cr>', { desc = 'Start PR review' })
    map('n', '<leader>gR', '<cmd>Octo review resume<cr>', { desc = 'Resume PR review' })
    map('n', '<leader>gs', '<cmd>Octo review submit<cr>', { desc = 'Submit PR review' })
end

function M.fugitive() map('n', '<leader>gg', '<cmd>Git<cr>', { desc = 'Show vim-fugitive (Git)' }) end

---@param bufnr integer
function M.gitsigns(bufnr)
    local gitsigns = require('gitsigns')

    local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
    end

    -- Navigation
    map('n', ']c', function()
        if vim.wo.diff then
            vim.cmd.normal({ ']c', bang = true })
        else
            gitsigns.nav_hunk('next')
        end
    end, { desc = 'Jump to next git [c]hange' })

    map('n', '[c', function()
        if vim.wo.diff then
            vim.cmd.normal({ '[c', bang = true })
        else
            gitsigns.nav_hunk('prev')
        end
    end, { desc = 'Jump to previous git [c]hange' })

    -- Actions
    -- visual mode
    map(
        'v',
        '<leader>hs',
        function() gitsigns.stage_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
        { desc = 'git [s]tage hunk' }
    )
    map(
        'v',
        '<leader>hr',
        function() gitsigns.reset_hunk({ vim.fn.line('.'), vim.fn.line('v') }) end,
        { desc = 'git [r]eset hunk' }
    )
    -- normal mode
    map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
    map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
    map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
    map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
    map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
    map('n', '<leader>hi', gitsigns.preview_hunk_inline, { desc = 'git preview hunk [i]nline' })
    map(
        'n',
        '<leader>hb',
        function() gitsigns.blame_line({ full = true }) end,
        { desc = 'git [b]lame line' }
    )
    map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
    map(
        'n',
        '<leader>hD',
        function() gitsigns.diffthis('@') end,
        { desc = 'git [D]iff against last commit' }
    )
    map('n', '<leader>hQ', function() gitsigns.setqflist('all') end)
    map('n', '<leader>hq', gitsigns.setqflist)
    -- Toggles
    map(
        'n',
        '<leader>tb',
        gitsigns.toggle_current_line_blame,
        { desc = '[T]oggle git show [b]lame line' }
    )
    map('n', '<leader>tw', gitsigns.toggle_word_diff)

    -- Text object
    map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
end

function M.telescope()
    -- File Pickers
    map(
        'n',
        '<leader>fw',
        function() require('telescope').extensions.live_grep_args.live_grep_args() end,
        { desc = 'Telescope Live Grep' }
    )
    map(
        'n',
        '<leader>ff',
        function() require('telescope.builtin').find_files() end,
        { desc = 'Telescope Find Files' }
    )

    -- LSP Pickers
    map(
        'n',
        '<leader>ft',
        function() require('telescope.builtin').lsp_dynamic_workspace_symbols() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        '<leader>fs',
        function() require('telescope.builtin').lsp_document_symbols() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        'gd',
        function() require('telescope.builtin').lsp_definitions() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        'gt',
        function() require('telescope.builtin').lsp_type_definitions() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        'gr',
        function() require('telescope.builtin').lsp_references() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        'gi',
        function() require('telescope.builtin').lsp_implementations() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        '<leader>fd',
        function() require('telescope.builtin').diagnostics() end,
        { desc = 'Telescope Workspace Symbols' }
    )

    -- Vim
    map(
        'n',
        '<leader>fh',
        function() require('telescope.builtin').highlights() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        '<leader>fH',
        function() require('telescope.builtin').help_tags() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        '<leader>fk',
        function() require('telescope.builtin').keymaps() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        '<leader>fq',
        function() require('telescope.builtin').quickfix() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        '<leader>fc',
        function() require('telescope.builtin').commands() end,
        { desc = 'Telescope Workspace Symbols' }
    )
    map(
        'n',
        '<leader>fb',
        function() require('telescope.builtin').buffers() end,
        { desc = 'Telescope Workspace Symbols' }
    )
end

---@param event vim.api.keyset.create_autocmd.callback_args
function M.lsp(event)
    map(
        'n',
        'K',
        function() vim.lsp.buf.hover({ border = CHARS.border_chars_outer_thin }) end,
        { desc = 'Hover Documentation', buffer = event.buf }
    )
    map(
        'n',
        '<leader>d',
        function() vim.diagnostic.open_float(nil, { scope = 'cursor' }) end,
        { desc = 'Show Diagnostics', buffer = event.buf }
    )

    map('n', 'cd', vim.lsp.buf.rename, { desc = '[R]e[n]ame', buffer = event.buf })
    map(
        { 'n', 'x' },
        '<leader>ca',
        vim.lsp.buf.code_action,
        { desc = '[C]ode [A]ction', buffer = event.buf }
    )

    -- The following code creates a keymap to toggle inlay hints in your
    -- code, if the language server you are using supports them
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map(
            'n',
            '<leader>th',
            function()
                vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end,
            { desc = '[T]oggle Inlay [H]ints', buffer = event.buf }
        )
    end
end

function M.noneckpain() map('n', '<leader>=', '<cmd>NoNeckPain<cr>', { desc = 'Toggle NoNeckPain' }) end

function M.flash()
    map({ 'n', 'x', 'o' }, 'ss', function() require('flash').jump() end, { desc = 'Flash' })
    map(
        { 'n', 'x', 'o' },
        'SS',
        function() require('flash').treesitter() end,
        { desc = 'Flash Treesitter' }
    )
end

function M.oil()
    local oil = require('oil')
    local last_dir = nil

    vim.api.nvim_create_autocmd('BufLeave', {
        pattern = 'oil://*',
        callback = function() last_dir = oil.get_current_dir() end,
    })

    map('n', '<leader>e', function() oil.toggle_float() end, { desc = 'Open Oil file [e]xplorer' })
    map(
        'n',
        '<leader>E',
        function() oil.open_float(last_dir) end,
        { desc = 'Open Oil at last opened folder' }
    )
end

return M
