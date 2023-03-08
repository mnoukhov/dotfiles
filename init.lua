local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options


-------------------- PLUGINS -------------------------------
require "paq" {
    'savq/paq-nvim';

    {'nvim-treesitter/nvim-treesitter'},
    {'nvim-treesitter/nvim-treesitter-context'},
    {'nvim-treesitter/nvim-treesitter-textobjects'},
    {'neovim/nvim-lspconfig'};           -- Collection of configurations for built-in LSP client
    {'hrsh7th/nvim-cmp'};                -- Autocompletion plugin
    {'hrsh7th/cmp-nvim-lsp'};            -- LSP source for nvim-cmp
    {'saadparwaiz1/cmp_luasnip'};        -- Snippets source for nvim-cmp
    {'L3MON4D3/LuaSnip'};                -- Snippets plugin
    {'lervag/vimtex'};

    -- FZF
    {'junegunn/fzf'};
    {'junegunn/fzf.vim'};

    {'junegunn/goyo.vim'};
    {'ojroques/nvim-lspfuzzy'};
    {'numToStr/Comment.nvim'};

    -- style
    {'junegunn/seoul256.vim'};
    'nvim-lualine/lualine.nvim';        -- statusline
    'kyazdani42/nvim-web-devicons';     -- icons for the statusline
    {'edkolev/tmuxline.vim'};
    {'kdheepak/tabline.nvim'};
    {"folke/which-key.nvim", run = function() vim.o.timeout = true vim.o.timeoutlen = 300 end };

    {'tpope/vim-fugitive'};
    {'tpope/vim-rhubarb'};

    {'superevilmegaco/AutoRemoteSync.nvim'};
    {'chipsenkbeil/distant.nvim'};
}


-------------------- OPTIONS -------------------------------
cmd 'colorscheme seoul256'            -- Put your favorite colorscheme here
opt.completeopt = {'menuone', 'noinsert', 'noselect'}  -- Completion options (for deoplete)
opt.expandtab = true                -- Use spaces instead of tabs
opt.hidden = true                   -- Enable background buffers
opt.ignorecase = true               -- Ignore case
opt.joinspaces = false              -- No double spaces with join
opt.list = true                     -- Show some invisible characters
opt.number = true                   -- Show line numbers
-- opt.relativenumber = true           -- Relative line numbers
opt.scrolloff = 4                   -- Lines of context
opt.shiftround = true               -- Round indent
opt.shiftwidth = 4                  -- Size of an indent
opt.sidescrolloff = 8               -- Columns of context
opt.smartcase = true                -- Do not ignore case with capitals
opt.smartindent = true              -- Insert indents automatically
opt.splitbelow = true               -- Put new windows below current
opt.splitright = true               -- Put new windows right of current
opt.tabstop = 4                     -- Number of spaces tabs count for
opt.termguicolors = true            -- True color support
opt.wildmode = {'list', 'longest'}  -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap


-------------------- MAPPINGS ------------------------------
vim.g.mapleader = '\\'

local function map(mode, lhs, rhs, opts)
    local options = {noremap = true}
    if opts then options = vim.tbl_extend('force', options, opts) end
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

map('i', 'jj', '<Esc>')             -- jj to escape in insert
map('n', '<Esc>', '<cmd>noh<CR>')   -- escape to remove highlight

-- tab to navigate completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})

-- control h and l to change between buffer tabs
map('n', '<C-h>', '<cmd>bprevious<CR>')
map('n', '<C-l>', '<cmd>bnext<CR>')
map('n', '<C-x>', '<cmd>bdelete<CR>')


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

-------------------- LSP -----------------------------------
local lsp = require 'lspconfig'
local lspfuzzy = require 'lspfuzzy'

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=false, buffer=bufnr }
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>a', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
    vim.lsp.set_log_level("debug")

    -- vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
end


-- We use the default settings for ccls and pylsp: the option table can stay empty
lsp.pylsp.setup {
    on_attach = on_attach,
    filetypes = {"python"},
    settings = {
        pyslp = {
            plugins = {
                -- black = { enabled = true },
                -- isort = { enabled = true, profile = "black" },
                pycodestyle = {enabled = true},
                pylsp_black = {enabled = true},
                pylsp_isort = {enabled = true},
                -- disabled standard plugins
                autopep8 = {enabled = false},       -- covered by black
                yapf = {enabled = false},           -- covered by black
                pydocstyle = {enabled = false},
            },
        },
    }
}
lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list


-- map('n', '<leader>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
-- map('n', '<leader>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
-- map('n', '<leader>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
-- map('n', '<leader>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
-- map('n', '<leader>f', '<cmd>lua vim.lsp.buf.format()<CR>')
-- map('n', '<leader>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
-- map('n', '<leader>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
-- map('n', '<leader>r', '<cmd>lua vim.lsp.buf.references()<CR>')
-- map('n', '<leader>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

-------------------- DISTANT --------------------------------
require('distant').setup {
    -- applies chip's personal settings to every machine you connect to
    --
    -- 1. ensures that distant servers terminate with no connections
    -- 2. provides navigation bindings for remote directories
    -- 3. provides keybinding to jump into a remote file's parent directory
    ['*'] = require('distant.settings').chip_default()
}


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
        max_bufferline_percent = 66, -- set to nil by default, and it uses vim.o.columns * 2/3
        show_devicons = true, -- this shows devicons in buffer section
        show_filename_only = true, -- shows base filename only instead of relative path in filename
    }
}


-------------------- Which-Key --------------------------------
require 'which-key'.setup()

