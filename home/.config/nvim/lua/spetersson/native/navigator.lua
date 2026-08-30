local is_herdr = vim.env.HERDR_ENV == '1'
local is_kitty = not is_herdr and (vim.env.TERM == 'xterm-kitty' or vim.env.KITTY_LISTEN_ON ~= nil)
local is_tmux = vim.env.TMUX ~= nil and vim.env.TMUX ~= ''

local direction_map = { h = 'left', j = 'bottom', k = 'top', l = 'right' }
local herdr_direction = { h = 'left', j = 'down', k = 'up', l = 'right' }
local tmux_flag = { h = 'L', j = 'D', k = 'U', l = 'R' }

local function navigate(direction)
    local cur_win = vim.api.nvim_get_current_win()
    vim.cmd('wincmd ' .. direction)

    if vim.api.nvim_get_current_win() ~= cur_win then return end

    if is_herdr then
        vim.system({ vim.env.HERDR_BIN_PATH or 'herdr', 'pane', 'focus', '--current', '--direction', herdr_direction[direction] })
    elseif is_tmux then
        vim.fn.system(
            'tmux -S ' .. vim.split(vim.env.TMUX, ',')[1] .. ' select-pane -t ' .. vim.fn.shellescape(vim.env.TMUX_PANE) .. ' -' .. tmux_flag[direction]
        )
    elseif is_kitty then
        vim.system({
            'kitten',
            '@',
            '--to',
            vim.env.KITTY_LISTEN_ON,
            'focus-window',
            '--match',
            'neighbor:' .. direction_map[direction],
        })
    end
end

-- Signal to kitty that this window is running Neovim,
-- so kitty passes ctrl+h/j/k/l through instead of handling them.
if is_kitty then
    io.write('\027]1337;SetUserVar=IS_NVIM=' .. vim.base64.encode('1') .. '\007')
    io.flush()

    vim.api.nvim_create_autocmd('VimLeavePre', {
        desc = 'Unset IS_NVIM kitty user variable on exit',
        group = vim.api.nvim_create_augroup('navigator', { clear = true }),
        callback = function()
            io.write('\027]1337;SetUserVar=IS_NVIM\007')
            io.flush()
        end,
    })
end

for key, dir_name in pairs(direction_map) do
    -- Mapped in visual mode too, without leaving it: when the move falls through
    -- to a multiplexer pane (e.g. pi), nvim stays in Visual and the AI bridge reads the
    -- live selection.
    vim.keymap.set({ 'n', 'x' }, '<C-' .. key .. '>', function() navigate(key) end, { silent = true, desc = 'Navigate ' .. dir_name })
end
