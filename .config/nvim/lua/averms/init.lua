--- Commands: useful but not enough to become mappings

-- Taken from editorconfig.lua
vim.api.nvim_create_user_command("Strip", function()
  local view = vim.fn.winsaveview()
  vim.api.nvim_command [[silent keepjumps keeppatterns %s/[ \t\r]\+$//e]]
  vim.fn.winrestview(view)
end, { desc = "strip trailing whitespace" })

vim.api.nvim_create_user_command("Bufonly", function()
  local current = vim.api.nvim_get_current_buf()
  local kept = 0
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if bufnr ~= current then
      if not pcall(vim.api.nvim_buf_delete, bufnr, {}) then
        kept = kept + 1
      end
    end
  end
  if kept > 0 then
    vim.notify(("Bufonly: kept %d buffer(s)"):format(kept), vim.log.levels.WARN)
  end
end, { desc = "delete all buffers but the current" })

--- Ftdetect

vim.filetype.add {
  extension = {
    cross = "conf",
    bu = "yaml",
    sig = function() end,
  },
}

--- Built-in plugin configuration

vim.g.python_no_doctest_highlight = 1

vim.g.perl_sub_signatures = 1
vim.g.perl_include_pod = 0

vim.g.sh_no_error = 1

vim.g.make_no_commands = 1

vim.g.tex_flavor = "latex"
-- Error highlighting has a lot of false positives
vim.g.tex_no_error = 1
-- Don't conceal sub/super script because that makes it hard to read
vim.g.tex_conceal = "admg"

vim.g.vimsyn_noerror = 1
vim.g.vim_indent_cont = vim.o.shiftwidth

vim.g.gitcommit_summary_length = 72

vim.g.vim_json_warnings = 0

--- Simple plugins

vim.cmd "packadd! nvim.undotree"

local function gh(user_repo)
  return "https://github.com/" .. user_repo .. ".git"
end

-- My little lazy.nvim knockoff
local function use(plugins)
  vim.pack.add(plugins)
  for _, p in ipairs(plugins) do
    if p.config then
      if p.defer then
        vim.schedule(p.config)
      else
        p.config()
      end
    end
  end
end

use {
  {
    src = gh "nvim-mini/mini.nvim",
    version = "stable",
    config = function()
      require("mini.ai").setup {
        n_lines = 500,
        -- Free an/in and al/il for built-in treesitter selection
        mappings = {
          around_last = "",
          around_next = "",
          inside_last = "",
          inside_next = "",
        },
      }

      require("mini.align").setup()

      -- Copy tpope keybinds
      local surround = require "mini.surround"
      surround.setup {
        mappings = {
          add = "ys",
          delete = "ds",
          replace = "cs",
          find = "",
          find_left = "",
          highlight = "",
          update_n_lines = "",
          suffix_last = "",
          suffix_next = "",
        },
      }
      vim.keymap.del("x", "ys")
      vim.keymap.set("x", "S", function()
        vim.cmd.normal { vim.keycode "<Esc>", bang = true }
        surround.add "visual"
      end, { desc = "Add surrounding to selection" })

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

      require("mini.misc").setup_restore_cursor {
        ignore_filetype = { "gitcommit", "gitrebase", "jjdescription" },
      }
    end,
  },
  {
    src = gh "dhruvasagar/vim-table-mode",
    config = function()
      vim.g.table_mode_corner = "|"
    end,
  },
  { src = gh "lambdalisue/vim-suda" },
  {
    src = gh "Vimjas/vim-python-pep8-indent",
    config = function()
      vim.g.python_pep8_indent_multiline_string = -1
    end,
  },
}

--- Fancy, expensive plugins. Also stuff not useful inside VS Code.

if vim.g.averms_minimal_init then
  return
end

-- Statusline

local cwd = "• %.60{fnamemodify(getcwd(),':~')} "
local newline_label = " %{&ff ==# 'unix' ? 'LF' : &ff ==# 'dos' ? 'CRLF' : 'CR'} %y"
local default_stl = vim.api.nvim_get_option_info2("statusline", {}).default
local spliced, n = default_stl:gsub("%%=", function()
  return cwd .. "%="
end, 1)
assert(n == 1, "statusline default has no %= to splice into")
vim.o.statusline = spliced .. newline_label
vim.o.rulerformat = "%l:%c"

use {
  -- TODO: run cargo build --release on update, maybe PackChanged?
  { src = gh "eraserhd/parinfer-rust" },
  {
    src = gh "Olical/conjure",
    config = function()
      vim.g["conjure#filetypes"] = { "clojure", "fennel", "racket", "scheme" }
    end,
  },
  {
    src = gh "folke/zen-mode.nvim",
    defer = true,
    config = function()
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
    end,
  },
  {
    src = gh "stevearc/oil.nvim",
    defer = true,
    config = function()
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
    end,
  },
  {
    src = gh "ibhagwan/fzf-lua",
    defer = true,
    config = function()
      require("fzf-lua").setup {
        winopts = {
          treesitter = false,
          height = 0.6,
          width = 0.7,
        },
        defaults = { git_icons = false, file_icons = false },
      }

      -- Press <alt-i> to toggle ignored files, press <ctrl-v> to open in a vsplit
      vim.keymap.set("n", "<leader>b", "<cmd>FzfLua buffers<cr>")
      vim.keymap.set("n", "<leader>e", "<cmd>FzfLua files<cr>")
      vim.keymap.set("n", "<leader>o", "<cmd>FzfLua oldfiles<cr>")
      vim.keymap.set("n", "gS", "<cmd>FzfLua lsp_workspace_symbols<cr>")
    end,
  },
  {
    src = gh "saghen/blink.cmp",
    version = "v1.10.2",
    defer = true,
    config = function()
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
    end,
  },
  {
    src = gh "neovim/nvim-lspconfig",
    defer = true,
    config = function()
      vim.diagnostic.config { virtual_lines = { current_line = true } }

      -- Put diagnostics in the loclist and open it
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)

      vim.lsp.semantic_tokens.enable(false)
      vim.lsp.inlay_hint.enable(true)

      vim.lsp.config["*"] = {
        root_markers = { ".git" },
      }

      vim.lsp.config.clangd = {
        cmd = { "clangd", "--header-insertion=never" },
      }

      vim.lsp.config.harper_ls = {
        settings = {
          ["harper-ls"] = {
            linters = {
              UseTitleCase = false,
              -- Too many false positives cause harper doesn't know verbs
              NeedToNoun = false,
            },
          },
        },
      }

      -- Don't enable harper by default, only toggle with this shortcut
      vim.keymap.set("n", "<leader>ss", function()
        local is_enabled = vim.lsp.is_enabled "harper_ls"
        vim.lsp.enable("harper_ls", not is_enabled)
      end)

      vim.lsp.config.markdown_oxide = {
        workspace_required = true,
      }

      vim.lsp.config.ty = {
        settings = {
          ty = {
            inlayHints = {
              callArgumentNames = false,
              variableTypes = false,
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
              command = "clippy",
            },
          },
        },
      }

      vim.lsp.config.gopls = {
        settings = {
          gopls = { completeFunctionCalls = false },
        },
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
    end,
  },
}
