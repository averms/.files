--
-- The beginning of my config in Lua.
--

--[[
git clone --filter=blob:none https://github.com/echasnovski/mini.nvim.git \
    ~/.local/share/nvim/site/pack/deps/start/mini.nvim
--]]

require("mini.deps").setup()
local add = function(spec)
    MiniDeps.add(spec, { bang = true })
end

-- Simple plugins

require("mini.ai").setup()

require("mini.align").setup()

require("mini.comment").setup()

-- Copy tpope keybinds
require("mini.surround").setup {
    mappings = {
        add = "ys",
        delete = "ds",
        replace = "cs",
        find = "",
        find_left = "",
        highlight = "",
        highlight = "",
        update_n_lines = "",
        suffix_last = "",
        suffix_next = "",
    },
}
vim.keymap.del('x', 'ys')
vim.keymap.set("x", "S", [[:<C-u>lua MiniSurround.add('visual')<CR>]], { silent = true })

require("mini.operators").setup {
    exchange = { prefix = "cx" },
    evaluate = { prefix = "" },
    multiply = { prefix = "" },
    replace = { prefix = "" },
    sort = { prefix = "" },
}

add "justinmk/vim-dirvish"
vim.g.dirvish_mode = 2

add "urbainvaes/vim-ripple"
vim.g.ripple_enable_mappings = 1
vim.g.ripple_repls = {
    lua = "ilua -i luajit",
    scheme = "racket -i",
    python = "ipython --no-autoindent",
}

add "dhruvasagar/vim-table-mode"
vim.g.table_mode_corner = "|"

add "lambdalisue/suda.vim"
add "mbbill/undotree"
add "dstein64/vim-startuptime"
add "farmergreg/vim-lastplace"

-- Some filetype plugins

add "Glench/Vim-Jinja2-Syntax"
add "chrisbra/vim-xml-runtime"
add "pboettch/vim-cmake-syntax"
add "fladson/vim-kitty"

add "Vimjas/vim-python-pep8-indent"
vim.g.python_pep8_indent_multiline_string = -1

vim.g.python_no_doctest_highlight = 1
vim.g.python_recommended_style = 0

vim.g.perl_sub_signatures = 1
vim.g.perl_include_pod = 0

vim.g.sh_no_error = 1

vim.g.make_no_commands = 1

vim.g.rst_style = 0
vim.g.rst_fold_enabled = 0

vim.g.tex_flavor = "latex"
-- error highlighting has a lot of false positives
vim.g.tex_no_error = 0
-- don't conceal sub/super script because that makes it hard to read
vim.g.tex_conceal = "admg"

vim.g.vimsyn_folding = 0
vim.g.vimsyn_noerror = 1

if vim.g.minimal_init then
    return
end

-- Fancy LSP plugins

add "neovim/nvim-lspconfig"
local lspconfig = require "lspconfig"

local full_capabilities = vim.lsp.protocol.make_client_capabilities()
full_capabilities.textDocument.completion.completionItem.snippetSupport = false

-- lspconfig.clangd.setup {
--     cmd = { "clangd", "--header-insertion=never" },
--     capabilities = full_capabilities,
-- }
-- lspconfig.rust_analyzer.setup {
--     capabilities = full_capabilities,
-- }

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("user_lsp_config", { clear = true }),
    callback = function(event)
        local opts = { buffer = event.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<c-x>", vim.lsp.buf.signature_help, opts)
        vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set({ "n", "v" }, "<enter>", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<space>f", function()
            vim.lsp.buf.format { async = true }
        end, opts)

        -- Don't like semantic highlighting.
        local client = vim.lsp.get_client_by_id(event.data.client_id)
        client.server_capabilities.semanticTokensProvider = nil
    end,
})

vim.diagnostic.config { virtual_text = false }
