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

    -- LSP
    {'VonHeikemen/lsp-zero.nvim', branch = 'v3.x'},
    {'neovim/nvim-lspconfig'},           -- Collection of configurations for built-in LSP client
    {'hrsh7th/nvim-cmp'},                -- Autocompletion plugin
    {'hrsh7th/cmp-nvim-lsp'},            -- LSP source for nvim-cmp
    {'hrsh7th/cmp-buffer'},
    -- {'saadparwaiz1/cmp_luasnip'},        -- Snippets source for nvim-cmp
    {'L3MON4D3/LuaSnip', version = "v2.*"},                -- Snippets plugin
    {'lervag/vimtex'},
    {'joechrisellis/lsp-format-modifications.nvim'},
    {'williamboman/mason.nvim'};
    {'williamboman/mason-lspconfig.nvim'};

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
    -- -- FZF
    -- {'junegunn/fzf'},
    -- {'junegunn/fzf.vim'},
    -- {'ojroques/nvim-lspfuzzy'},

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
    {'superevilmegaco/AutoRemoteSync.nvim'},
    -- {'chipsenkbeil/distant.nvim'};
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
g.python3_host_prog = '/home/toolkit/.conda/envs/default/bin/python'
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
map('n', '<Esc>', '<cmd>noh<CR>')   -- escape to remove highlight

-- -- -- tab to navigate completion menu
-- map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
-- map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})


-- control h and l to change between buffers
map('n', '<C-h>', '<cmd>bprevious<CR>')
map('n', '<C-l>', '<cmd>bnext<CR>')
map('n', '<C-d>', '<cmd>bdelete<CR>')

-- -- fzf --
-- map('n', '<C-p>', '<cmd>Files<CR>')

-- fugitive --
map('n', '<leader>g', '<cmd>Git<CR>', {desc = "Git"})

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
local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

cmp.setup({
  mapping = cmp.mapping.preset.insert({
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<Tab>'] = cmp_action.luasnip_supertab(),
    ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
  })
})


-------------------- LSP -----------------------------------
--debug
-- vim.lsp.set_log_level("debug")
--
local lsp_zero = require('lsp-zero')
-- lsp_zero.extend_lspconfig()

lsp_zero.on_attach(function(client, bufnr)
    -- See :help lsp-zero-keybindings
    lsp_zero.default_keymaps({buffer = bufnr, preserve_mappings = False})
    vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', {buffer = bufnr, desc = "Go to References"})
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {buffer = bufnr, desc = "Go to Definition"})
    -- vim.keymap.set('n', 'gq', vim.diagnostic.setloclist, {buffer = bufnr, desc = "Open Location List"})
    -- vim.keymap.set('n', 'gl', vim.diagnostic.open_float, {buffer = bufnr, desc = "Open Diagnostics Float"})
    -- Toggle LocList
    -- vim.keymap.set("n", "gq", function()
    --     vim.diagnostic.setloclist({ open = false }) -- don't open and focus
    --     local window = vim.api.nvim_get_current_win()
    --     vim.cmd.lwindow() -- open+focus loclist if has entries, else close -- this is the magic toggle command
    --     vim.api.nvim_set_current_win(window) -- restore focus to window you were editing (delete this if you want to stay in loclist)
    -- end, { buffer = bufnr , desc = "Open Diagnostics List"})


    lsp_zero.buffer_autoformat()
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        pattern = { "*.py" },
        callback = function()
            vim.lsp.buf.code_action {
            context = {
                only = { 'source.organizeImports.ruff' },
            },
            apply = true,
            }
        end,
    })

    -- vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format() ]]
    -- vim.api.nvim_create_autocmd(
    --     { "BufWritePre" },
    --     {
    --         -- group = augroup_id,
    --         buffer = bufnr,
    --         callback = function()
    --             require("lsp-format-modifications").format_modifications(client, bufnr)
    --         end,
    --     }
    -- )
end)

local lspconfig = require('lspconfig')
lspconfig.pyright.setup {
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
    },
  },
}
lspconfig.autotools_ls.setup{}
local ruff_config_path = vim.loop.cwd() .. '/pyproject.toml'
lspconfig.ruff.setup({
    init_options = {
        settings = {
            format = {
                args = { "--config", ruff_config_path }
            },
            lint = {
                args = { "--config", ruff_config_path }
            }
        }
    }
})
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, {desc = "Open Float"})
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, {desc = "Open Location List"})


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
-- vim.g['tmuxline_theme'] = 'vim_statusline_1'

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
-- require 'neo-tree'

require('leap').add_default_mappings()

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
require("trouble").setup(
{
  modes = {
    diagnostics_buffer = {
      mode = "diagnostics", -- inherit from diagnostics mode
      filter = { buf = 0 }, -- filter diagnostics to the current buffer
    },
  }
}
)
