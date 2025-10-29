local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options

vim.g.mapleader = '\\'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-------------------- PLUGINS -------------------------------
require("lazy").setup({
    -- Utils
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",

    {'L3MON4D3/LuaSnip', version = "v2.*"},                -- Snippets plugin
    {'lervag/vimtex'},

    -- Treesitter
    {'nvim-treesitter/nvim-treesitter', build = ":TSUpdate"},
    {'nvim-treesitter/nvim-treesitter-context'},
    {'nvim-treesitter/nvim-treesitter-textobjects'},

    -- Telescope
    {
        'nvim-telescope/telescope.nvim', 
        version = '0.1.x', 
        dependencies = { 'nvim-lua/plenary.nvim' }
    },

    -- motions and ux
    {'numToStr/Comment.nvim'},
    {
        "folke/which-key.nvim", 
        event = "VeryLazy", 
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
    },
    {'tpope/vim-fugitive'},
    {'tpope/vim-rhubarb'},
    {'tpope/vim-eunuch'},
    {'ggandor/leap.nvim'},

    -- Neotree
    {"nvim-neo-tree/neo-tree.nvim", branch = "v3.x"},

    -- style
    {'junegunn/goyo.vim'},
    {'junegunn/seoul256.vim'},
    -- {'shaunsingh/seoul256.nvim'},

    'nvim-lualine/lualine.nvim',        -- statusline
    'kyazdani42/nvim-web-devicons',     -- icons for the statusline
    {'edkolev/tmuxline.vim'},
    {'kdheepak/tabline.nvim'},
    --

    -- Functionality
    {'neovim/nvim-lspconfig'},           -- Collection of configurations for built-in LSP client
    {"stevearc/conform.nvim", opts = {}},
    {
        "folke/trouble.nvim",
        opts = {}, -- for default options, refer to the configuration section for custom setup.
        cmd = "Trouble",
        keys = {
            {
                "<leader>x",
                "<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<cr>",
                desc = "Buffer Diagnostics (Trouble)",
            },
            {
                "<leader>cs",
                "<cmd>Trouble symbols toggle focus=false win.position=left<cr>",
                desc = "Symbols (Trouble)",
            },
            {
                "<leader>cl",
                "<cmd>Trouble lsp toggle focus=false win.position=left<cr>",
                desc = "LSP Definitions / references / ... (Trouble)",
            },
            {
                "<leader>l",
                "<cmd>Trouble loclist toggle<cr>",
                desc = "Location List (Trouble)",
            },
            {
                "<leader>q",
                "<cmd>Trouble qflist toggle<cr>",
                desc = "Quickfix List (Trouble)",
            },
        },
    }
})


-------------------- OPTIONS -------------------------------
-- colors
g.seoul256_background = 237
g.seoul256_srgb = 1
vim.cmd 'colorscheme seoul256'            -- Put your favorite colorscheme here

opt.expandtab = true                -- Use spaces instead of tabs
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = 4                  -- Size of an indent
-- opt.sidescrolloff = 8               -- Columns of context
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = 4                     -- Number of spaces tabs count for
opt.termguicolors = true            -- True color support
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap


-------------------- MAPPINGS ------------------------------

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('i', 'jj', '<Esc>')             -- jj to escape in insert
map('n', ';;', '<cmd>:w<CR>')             -- ;; to save
map('n', '<Esc>', '<cmd>noh<CR>')   -- escape to remove highlight

-- -- -- tab to navigate completion menu
-- map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
-- map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})


-- control h and l to change between buffers
map('n', '<C-h>', '<cmd>bprevious<CR>')
map('n', '<C-l>', '<cmd>bnext<CR>')
map('n', '<C-d>', '<cmd>bdelete<CR>')

-- fugitive --
map('n', '<leader>g', '<cmd>Git ++curwin<CR>', {desc = "Git"})

-- show current path --
map('n', '<leader>p', '<cmd>echo expand("%:p")<CR>', {desc = "Show current path"})

-------------------- COMMENT -------------------------------
require('Comment').setup()

-------------------- TREE-SITTER ---------------------------
require 'nvim-treesitter.configs'.setup {
    ensure_installed = {'python', 'markdown', 'lua'}, 
    highlight = {enable = true},
    auto_install = true,
}

-- do folds
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

require('treesitter-context').setup({
    multiline_threshold = 5,
})

--
-------------------- CMP  -----------------------------------
-- local cmp = require('cmp')
--
-- cmp.setup({
--   mapping = cmp.mapping.preset.insert({
--     ['<C-Space>'] = cmp.mapping.complete(),
--     ['<Tab>'] = cmp_action.luasnip_supertab(),
--     ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
--   })
-- })


-------------------- LSP -----------------------------------
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local opts = {buffer = args.buf}

    vim.keymap.set('n', '<C-Space>', '<C-x><C-o>', opts)
    vim.keymap.set({'n', 'x'}, 'gq', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

    vim.keymap.set('n', 'grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
    vim.keymap.set('n', 'grd', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)

    vim.keymap.set('n', 'grr', '<cmd>Telescope lsp_references<cr>', {buffer = args.buf, desc = "Go to References"})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = args.buf, desc = "Go to Definition"})
  end,
})

vim.lsp.config('pyright', {
  settings = {
    pyright = {
      -- Using Ruff's import organizer
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- Ignore all files for analysis to exclusively use Ruff for linting
        ignore = { '*' },
      }, 
      pythonPath = ".venv/bin/python",
    },
  }
})

vim.lsp.enable('pyright')

vim.lsp.enable('autotools_ls')

-- local ruff_config_path = vim.loop.cwd() .. '/pyproject.toml'
vim.lsp.config('ruff', {
    -- init_options = {
    --     settings = {
    --         format = {
    --             args = { "--config", ruff_config_path }
    --         },
    --         lint = {
    --             args = { "--config", ruff_config_path }
    --         }
    --     }
    -- }
})

vim.lsp.enable('ruff')


-------------------- Lualine --------------------------------
require('lualine').setup {
    options = { 
        theme = 'seoul256',
        icons_enabled = false,
    },
    sections = {
        lualine_x = {},
    }
}

-------------------- Tmuxline --------------------------------
vim.g['tmuxline_theme'] = 'vim_statusline_1'

require 'nvim-web-devicons'.setup()

-------------------- Tabline --------------------------------
require 'tabline'.setup {
    -- defaults configuration options
    enable = true,
    options = {
        -- if lualine is installed tabline will use separators configured in lualine by default.
        -- these options can be used to override those settings.
        section_separators = {'', ''},
        component_separators = {'', ''},
        -- max_bufferline_percent = 100, -- set to nil by default, and it uses vim.o.columns * 2/3
        show_devicons = true, -- this shows devicons in buffer section
        show_filename_only = true, -- shows base filename only instead of relative path in filename
    }
}

-------------------- Which-Key --------------------------------
local wk = require 'which-key'
wk.add({
    {"<space>", group="workspace"},
})


------------------- Neo Tree ------------------------------
g.neo_tree_remove_legacy_commands = 1
map('n', '<leader>nt', '<cmd>Neotree<CR>', {desc = "Neotree"})
map('n', '<leader>nf', '<cmd>Neotree position=float<CR>', {desc = "Neotree Float"})
map('n', '<leader>nr', '<cmd>Neotree reveal position=float<CR>', {desc = "Neotree Float"})
-- require 'neo-tree'

------------------- Leap ------------------------------
require('leap')
vim.keymap.set({'n', 'x', 'o'}, 's', '<Plug>(leap)')
vim.keymap.set('n',             'S', '<Plug>(leap-from-window)')
require('leap').opts.preview = function (ch0, ch1, ch2)
  return not (
    ch1:match('%s')
    or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
  )
end

-- Define equivalence classes for brackets and quotes, in addition to
-- the default whitespace group:
require('leap').opts.equivalence_classes = {
  ' \t\r\n', '([{', ')]}', '\'"`'
}

-- Use the traversal keys to repeat the previous motion without
-- explicitly invoking Leap:
require('leap.user').set_repeat_keys('<enter>', '<backspace>')

------------------- Telescope ------------------------------
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {desc="Find Files"})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {desc="Live Grep"})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {desc="Find Buffers"})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {desc="Find Help Tags"})
vim.keymap.set('n', '<leader>fs', builtin.grep_string, {desc="Grep String under Cursor"})
vim.keymap.set('n', '<leader>f;', builtin.jumplist, {desc="Find Jumplist"})
vim.keymap.set('n', '<leader>f/', builtin.current_buffer_fuzzy_find, {desc="Current Buffer Fuzzy Find"})

-- require("telescope").setup({
--     pickers = {
--         find_files = {
--             find_command = {
--                 'fd',
--                 '--type',
--                 'f',
--                 '--no-ignore-vcs',
--                 '--color=never',
--                 '--hidden',
--                 '--follow',
--             }
--         }
--     }
-- })

---- Trouble ---
require("trouble").setup({
    modes = {
        diagnostics_buffer = {
            mode = "diagnostics", -- inherit from diagnostics mode
            filter = { buf = 0 }, -- filter diagnostics to the current buffer
        },
    }
})

require("conform").setup({
    formatters_by_ft = { 
        python = {
            -- To fix auto-fixable lint errors.
            "ruff_fix",
            -- To run the Ruff formatter.
            "ruff_format",
            -- To organize the imports.
            "ruff_organize_imports", 
        },
    },
    format_on_save = function(bufnr)
        -- Disable with a global or buffer-local variable
        if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
            return
        end
            return { timeout_ms = 500, lsp_format = "fallback" }
    end,
})
vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})
vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})
