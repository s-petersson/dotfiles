local CHARS = require('spetersson.utils.chars')

-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Tells other configurations/plugins that I have a Nerdfont installed
vim.g.have_nerd_font = true

vim.opt.number = true -- line number
vim.opt.relativenumber = true -- relative line numbers
vim.opt.cursorline = true -- highlight current line
vim.opt.wrap = false -- do not wrap lines by default
vim.opt.scrolloff = 10 -- keep 10 lines above/below cursor
vim.opt.sidescrolloff = 10 -- keep 10 lines to left/right of cursor

vim.opt.tabstop = 4 -- tabwidth
vim.opt.shiftwidth = 4 -- indent width
vim.opt.softtabstop = 4 -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smartindent = true -- smart auto-indent
vim.opt.autoindent = true -- copy indent from current line
vim.o.breakindent = true -- Enable break indent

vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case sensitive if uppercase in string
vim.opt.hlsearch = true -- highlight search matches
vim.opt.incsearch = true -- show matches as you type

vim.opt.signcolumn = 'yes' -- always show a sign column
-- vim.opt.colorcolumn = '100' -- show a column at 100 position chars
vim.opt.showmatch = true -- highlights matching brackets
vim.opt.cmdheight = 0 -- hide command line unless needed
vim.opt.showmode = false -- do not show the mode, instead have it in statusline
vim.opt.winblend = 0 -- floating window transparency

local undodir = vim.fn.expand('~/.vim/undodir')
if
    vim.fn.isdirectory(undodir) == 0 -- create undodir if nonexistent
then
    vim.fn.mkdir(undodir, 'p')
end

-- Sync clipboard between OS and Neovim.
-- Schedule the setting after `UiEnter` because it can increase startup-time.
-- Remove this option if you want your OS clipboard to remain independent.
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)

vim.opt.backup = false -- do not create a backup file
vim.opt.writebackup = false -- do not write to a backup file
vim.opt.swapfile = false -- do not create a swapfile
vim.opt.undofile = true -- do create an undo file
vim.opt.undodir = undodir -- set the undo directory

vim.opt.updatetime = 250 -- faster completion
vim.opt.timeoutlen = 300 -- timeout duration
vim.opt.ttimeoutlen = 50 -- key code timeout
vim.opt.autoread = true -- auto-reload changes if outside of neovim
vim.opt.autowrite = false -- do not auto-save

vim.opt.hidden = true -- allow hidden buffers
vim.opt.errorbells = false -- no error sounds
vim.opt.backspace = 'indent,eol,start' -- better backspace behaviour
vim.opt.autochdir = false -- do not autochange directories
vim.opt.iskeyword:append('-') -- include - in words
vim.opt.path:append('**') -- include subdirs in search
vim.opt.selection = 'inclusive' -- include last char in selection
vim.opt.mouse = 'a' -- enable mouse support
vim.opt.modifiable = true -- allow buffer modifications
vim.opt.encoding = 'utf-8' -- set encoding
vim.opt.termguicolors = true -- enable true-color highlights, including colored diagnostic underlines

-- Folding: requires treesitter available at runtime; safe fallback if not
vim.opt.foldmethod = 'expr' -- use expression for folding
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()' -- use treesitter for folding
vim.opt.foldlevel = 99 -- start with all folds open

-- enables treesitter based indentation
vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

vim.opt.splitbelow = true -- horizontal splits go below
vim.opt.splitright = true -- vertical splits go right

-- thicker window separators
vim.opt.fillchars = {
    eob = ' ',
    diff = '╱',
    vert = CHARS.right_thick,
    vertleft = CHARS.right_thick,
    vertright = CHARS.right_thick,
    verthoriz = CHARS.right_thick,
    horiz = CHARS.bottom_thin,
    horizup = CHARS.bottom_right_thin,
    -- horiz = '━',
    -- horizup = '┻',
    -- horizdown = '┳',
    -- vert = '┃',
    -- vertleft = '┫',
    -- vertright = '┣',
    -- verthoriz = '╋',
}
vim.opt.fillchars:append({ diff = ' ' }) -- use blank instead of strikethrough in diffs

vim.opt.wildmenu = true -- tab completion
vim.opt.wildmode = 'longest:full,full' -- complete longest common match, full completion list, cycle through with Tab
vim.opt.diffopt:append('linematch:60') -- improve diff display
vim.opt.redrawtime = 10000 -- increase neovim redraw tolerance
vim.opt.maxmempattern = 20000 -- increase max memory

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-guide-options`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- Custom tabline: show tab number + filename (not the full truncated path)
vim.o.tabline = '%!v:lua.Tabline()'
function Tabline()
    local s = ''
    for i = 1, vim.fn.tabpagenr('$') do
        local winnr = vim.fn.tabpagewinnr(i)
        local bufnr = vim.fn.tabpagebuflist(i)[winnr]
        local name = vim.fn.fnamemodify(vim.fn.bufname(bufnr), ':t')
        if name == '' then name = '[No Name]' end
        local hl = i == vim.fn.tabpagenr() and '%#TabLineSel#' or '%#TabLine#'
        s = s .. hl .. ' ' .. i .. ':' .. name .. ' '
    end
    return s .. '%#TabLineFill#'
end
