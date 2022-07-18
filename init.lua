local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options


-------------------- PLUGINS -------------------------------
require "paq" {
    'savq/paq-nvim';

    {'nvim-treesitter/nvim-treesitter', run=vim.fn[':TSUpdate']};
    {'neovim/nvim-lspconfig'};           -- Collection of configurations for built-in LSP client
    {'hrsh7th/nvim-cmp'};                -- Autocompletion plugin
    {'hrsh7th/cmp-nvim-lsp'};            -- LSP source for nvim-cmp
    {'saadparwaiz1/cmp_luasnip'};        -- Snippets source for nvim-cmp
    {'L3MON4D3/LuaSnip'};                -- Snippets plugin

    {'junegunn/fzf', run=vim.fn['fzf#install()']};
    {'junegunn/fzf.vim'};
    {'junegunn/goyo.vim'};
    {'ojroques/nvim-lspfuzzy'};
    {'numToStr/Comment.nvim'};

    -- style
    {'junegunn/seoul256.vim'};
    'nvim-lualine/lualine.nvim';        -- statusline
    'kyazdani42/nvim-web-devicons';     -- icons for the statusline

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


-------------------- COMMENT -------------------------------
require('Comment').setup()

-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = {'python', 'markdown', 'lua'}, highlight = {enable = true}}


-------------------- LSP -----------------------------------
local lsp = require 'lspconfig'
local lspfuzzy = require 'lspfuzzy'

-- We use the default settings for ccls and pylsp: the option table can stay empty
lsp.pylsp.setup {}
lspfuzzy.setup {}  -- Make the LSP client use FZF instead of the quickfix list

map('n', '<space>,', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>')
map('n', '<space>;', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>')
map('n', '<space>a', '<cmd>lua vim.lsp.buf.code_action()<CR>')
map('n', '<space>d', '<cmd>lua vim.lsp.buf.definition()<CR>')
map('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>')
map('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>')
map('n', '<space>m', '<cmd>lua vim.lsp.buf.rename()<CR>')
map('n', '<space>r', '<cmd>lua vim.lsp.buf.references()<CR>')
map('n', '<space>s', '<cmd>lua vim.lsp.buf.document_symbol()<CR>')

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
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_x = {},
    }
}

require 'nvim-web-devicons'.setup()

