--
-- The beginning of my config in Lua.
--

-- Set up mini.deps

local mini_path = vim.fn.stdpath "data" .. "/site/pack/deps/start/mini.nvim"

if not vim.loop.fs_stat(mini_path) then
    vim.cmd 'echo "Setting up mini.nvim" | redraw'
    local clone_cmd = {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/echasnovski/mini.nvim",
        mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd "packadd mini.nvim | helptags ALL"
end

require("mini.deps").setup()
local add = function(spec)
    MiniDeps.add(spec, { bang = true })
end

-- Simple plugins

require("mini.align").setup()

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

require("mini.operators").setup {
    exchange = { prefix = "cx" },
    evaluate = { prefix = "" },
    multiply = { prefix = "" },
    replace = { prefix = "" },
    sort = { prefix = "" },
}

add "averms-forks/xdg_open.vim"
if vim.fn.has "mac" == 1 then
    vim.g.xdg_open_command = "open"
end

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

add {
    source = "hrsh7th/nvim-cmp",
    depends = {
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp",
    },
}
local cmp = require "cmp"
cmp.setup {
    snippet = nil,

    sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "path" },
    },

    mapping = {
        ["<C-n>"] = function(fallback)
            cmp.select_next_item { behavior = cmp.SelectBehavior.Select }
        end,
        ["<C-p>"] = function(fallback)
            cmp.select_prev_item { behavior = cmp.SelectBehavior.Select }
        end,
        ["<Tab>"] = function(fallback)
            if cmp.visible() then
                cmp.confirm { select = true }
            else
                fallback()
            end
        end,
        ["<C-Space>"] = function(fallback)
            cmp.complete()
        end,
    },
}

add "neovim/nvim-lspconfig"
local lspconfig = require "lspconfig"

local full_capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
)
full_capabilities.textDocument.completion.completionItem.snippetSupport = false

lspconfig.clangd.setup {
    cmd = { "clangd", "--header-insertion=never" },
    capabilities = full_capabilities,
}
lspconfig.rust_analyzer.setup {
    capabilities = full_capabilities,
}

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
