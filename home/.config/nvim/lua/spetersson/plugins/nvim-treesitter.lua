local PARSERS = {
    'bash',
    'c',
    'diff',
    'html',
    'jinja',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'typescript',
    'javascript',
    'python',
    'yaml',
}

---@param buf integer
---@param language string
local function try_attach(buf, language)
    -- Check if parser exists and load it
    if not vim.treesitter.language.add(language) then return end
    -- Enables syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)
end

local treesitter = require('nvim-treesitter')

-- Ensure basic parser are installed
treesitter.install(PARSERS)

local available = treesitter.get_available()
vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        local buf, filetype = args.buf, args.match

        local lang = vim.treesitter.language.get_lang(filetype)
        if not lang then return end

        local installed = treesitter.get_installed('parsers')

        if vim.tbl_contains(installed, lang) then
            -- Enable the parser if it is installed
            try_attach(buf, lang)
        elseif vim.tbl_contains(available, lang) then
            -- If a parser is available in `nvim-treesitter` auto install it,
            -- and enable it after the installation is done
            treesitter.install(lang):await(function() try_attach(buf, lang) end)
        else
            -- Try to enable treesitter features in case the parser
            -- exists but is not available from `nvim-treesitter`
            try_attach(buf, lang)
        end
    end,
})
