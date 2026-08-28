---@type table<string, vim.lsp.Config>
local servers = {
    basedpyright = {},
    ruff = {},
    prettier = {},
    prettierd = {},

    stylua = {},
    lua_ls = {
        -- TODO: What does this even do?
        on_init = function(client)
            if client.workspace_folders then
                local path = client.workspace_folders[1].name
                if
                    path ~= vim.fn.stdpath('config')
                    and (
                        vim.uv.fs_stat(path .. '/.luarc.json')
                        or vim.uv.fs_stat(path .. '/.luarc.jsonc')
                    )
                then
                    return
                end
            end
        end,
        settings = {
            Lua = {},
        },
    },
}

require('mason-tool-installer').setup({ ensure_installed = vim.tbl_keys(servers) })

-- Now enable the the lsp clients
for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
end

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(event) require('spetersson.keymaps').lsp(event) end,
})
