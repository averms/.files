--- Commands: things that are useful but aren't used enough to become mappings.

vim.api.nvim_create_user_command("Strip", function()
  -- copied from editorconfig.lua.
  local view = vim.fn.winsaveview()
  vim.api.nvim_command "silent! undojoin"
  vim.api.nvim_command [[silent keepjumps keeppatterns %s/[ \t\r]\+$//e]]
  vim.fn.winrestview(view)
end, { desc = "strip trailing whitespace" })

vim.api.nvim_create_user_command("Bufonly", function()
  local bufs = vim.api.nvim_list_bufs()
  local current = vim.api.nvim_get_current_buf()
  for _, bufnr in ipairs(bufs) do
    if bufnr ~= current then
      vim.api.nvim_buf_delete(bufnr, {})
    end
  end
end, { desc = "delete all buffers but the current" })

--[[
git clone --filter=blob:none --branch stable \
    https://github.com/nvim-mini/mini.nvim.git \
    ~/.local/share/nvim/site/pack/deps/start/mini.nvim
--]]

require("mini.deps").setup()
local add = function(spec)
  MiniDeps.add(spec, { bang = true })
end
local later = MiniDeps.later
add { name = "mini.nvim", checkout = "stable" }

--- Simple plugins

require("mini.ai").setup {
  n_lines = 500,
}

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
vim.keymap.del("x", "ys")
vim.keymap.set("x", "S", ":<C-u>lua MiniSurround.add('visual')<cr>", { silent = true })

require("mini.operators").setup {
  exchange = { prefix = "cx" },
  evaluate = { prefix = "" },
  multiply = { prefix = "" },
  replace = { prefix = "" },
  sort = { prefix = "gs" },
}

require("mini.diff").setup {
  view = {
    style = "sign",
  },
}

add "dhruvasagar/vim-table-mode"
vim.g.table_mode_corner = "|"

add "folke/zen-mode.nvim"
require("zen-mode").setup {
  window = {
    width = 88,
    height = 0.9,
    options = {
      number = false,
    },
  },
  plugins = {
    options = {
      showcmd = false,
      winborder = "none",
    },
  },
}

add "lambdalisue/vim-suda"
add "mbbill/undotree"
add "farmergreg/vim-lastplace"

--- Some filetype plugins

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

vim.g.gitcommit_summary_length = 72

vim.g.vim_json_warnings = 0

--- Fancy, expensive plugins. Also stuff not useful inside VS Code.

if vim.g.minimal_init then
  return
end

add "stevearc/oil.nvim"
later(function()
  require("oil").setup {
    delete_to_trash = true,
    keymaps = {
      ["l"] = "actions.select",
      ["h"] = { "actions.parent", mode = "n" },
      ["<C-h>"] = false,
      ["<C-l>"] = false,
      ["`"] = false,
      ["<leader>cd"] = { "actions.cd", mode = "n" },
    },
  }
  vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory" })
end)

add "ibhagwan/fzf-lua"
later(function()
  require("fzf-lua").setup {
    winopts = {
      treesitter = false,
      height = 0.6,
      width = 0.7,
    },
    defaults = { git_icons = false, file_icons = false },
  }
end)

-- Press <alt-i> to toggle ignored files, press <ctrl-v> to open in a vsplit.
vim.keymap.set("n", "<leader>b", "<cmd>FzfLua buffers<cr>")
vim.keymap.set("n", "<leader>e", "<cmd>FzfLua files<cr>")
vim.keymap.set("n", "<leader>o", "<cmd>FzfLua oldfiles<cr>")
vim.keymap.set("n", "gS", "<cmd>FzfLua lsp_workspace_symbols<cr>")

add { source = "saghen/blink.cmp", checkout = "v1.10.2" }
later(function()
  require("blink.cmp").setup {
    cmdline = { enabled = false },
    completion = {
      list = {
        selection = {
          preselect = false,
          auto_insert = false,
        },
      },
      menu = { scrollbar = false },
    },
    fuzzy = {
      max_typos = function()
        return 0
      end,
    },
    sources = {
      default = { "lsp", "path" },
      providers = {
        path = {
          opts = {
            get_cwd = function(_)
              return vim.fn.getcwd()
            end,
          },
        },
      },
    },
    signature = {
      enabled = true,
      window = {
        show_documentation = false,
      },
    },
    keymap = { preset = "super-tab", ["<C-k>"] = {} },
  }
end)

vim.diagnostic.config { virtual_lines = { current_line = true } }

-- Put diagnostics in the loclist when you open it.
vim.diagnostic.handlers.loclist = {
  show = function(_, _, _, _)
    local winid = vim.api.nvim_get_current_win()
    vim.diagnostic.setloclist { open = false }
    vim.api.nvim_set_current_win(winid)
  end,
}

add { source = "neovim/nvim-lspconfig" }

vim.lsp.config["*"] = {
  root_markers = { ".git" },

  on_init = function(_, result)
    -- We don't want semantic highlighting.
    result.capabilities.semanticTokensProvider = nil
  end,

  on_attach = function(client, bufnr)
    if client:supports_method "textDocument/inlayHint" then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end
  end,
}

vim.lsp.config.clangd = {
  cmd = { "clangd", "--header-insertion=never" },
}

vim.lsp.config.harper_ls = {
  filetypes =  vim.list_extend(vim.lsp.config.harper_ls.filetypes, {"jjdescription"}),
  settings = {
    ["harper-ls"] = {
      linters = {
        UseTitleCase = false,
        -- too many false positives cause harper doesn't know verbs
        NeedToNoun = false,
      },
    },
  },
}

-- Don't enable harper by default, only toggle with this shortcut.
vim.keymap.set("n", "<leader>ss", function()
  local is_enabled = vim.lsp.is_enabled "harper"
  vim.lsp.enable("harper", not is_enabled)
end)


vim.lsp.config.markdown_oxide = {
  workspace_required = true,
}

vim.lsp.config.ty = {
  settings = {
    ty = {
      inlayHints = {
        callArgumentNames = false,
      },
    },
  },
}

vim.lsp.config.rust_analyzer = {
  settings = {
    ["rust-analyzer"] = {
      inlayHints = {
        parameterHints = { enable = false },
        typeHints = { enable = false },
        closingBraceHints = { enable = false },
      },
      completion = {
        callable = { snippets = "add_parentheses" },
        postfix = { enable = false },
        hideDeprecated = true,
      },
      check = {
          command = "clippy"
      },
    },
  },
}

vim.lsp.config.gopls = {
  settings = {
    gopls = { usePlaceholders = false },
  }
}

vim.lsp.enable {
  "bashls",
  "clangd",
  "gopls",
  "markdown_oxide",
  "ruff",
  "rust_analyzer",
  "ty",
}
