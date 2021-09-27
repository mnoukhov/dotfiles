local cmd = vim.cmd  -- to execute Vim commands e.g. cmd('pwd')
local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options


-------------------- PLUGINS -------------------------------
cmd 'packadd paq-nvim'               -- load the package manager
local paq = require('paq-nvim').paq  -- a convenient alias
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself

paq {'shougo/deoplete-lsp'}
paq {'shougo/deoplete.nvim', run = fn['remote#host#UpdateRemotePlugins']}
g['deoplete#enable_at_startup'] = 1  -- enable deoplete at startup
paq {'nvim-treesitter/nvim-treesitter'}
paq {'neovim/nvim-lspconfig'}

paq {'junegunn/fzf', run = fn['fzf#install']}
paq {'junegunn/fzf.vim'}
paq {'ojroques/nvim-lspfuzzy'}

paq {'junegunn/seoul256.vim'}
paq {'famiu/feline.nvim'}


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


-------------------- TREE-SITTER ---------------------------
local ts = require 'nvim-treesitter.configs'
ts.setup {ensure_installed = 'maintained', highlight = {enable = true}}


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



