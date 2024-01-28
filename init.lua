local fn = vim.fn    -- to call Vim functions e.g. fn.bufnr()
local g = vim.g      -- a table to access global variables
local opt = vim.opt  -- to set options


-------------------- PLUGINS -------------------------------
require "paq" {
    'savq/paq-nvim';

    -- Langs and LSP
    {'nvim-treesitter/nvim-treesitter'},
    {'nvim-treesitter/nvim-treesitter-context'},
    {'nvim-treesitter/nvim-treesitter-textobjects'},
    {'neovim/nvim-lspconfig'};           -- Collection of configurations for built-in LSP client
    {'hrsh7th/nvim-cmp'};                -- Autocompletion plugin
    {'hrsh7th/cmp-nvim-lsp'};            -- LSP source for nvim-cmp
    {'saadparwaiz1/cmp_luasnip'};        -- Snippets source for nvim-cmp
    {'L3MON4D3/LuaSnip'};                -- Snippets plugin
    {'lervag/vimtex'};
    {'joechrisellis/lsp-format-modifications.nvim'};

    -- FZF
    {'junegunn/fzf'};
    {'junegunn/fzf.vim'};
    -- {'ojroques/nvim-lspfuzzy'};

    -- motions and ux
    {'numToStr/Comment.nvim'};
    {"folke/which-key.nvim", build = function() vim.o.timeout = true vim.o.timeoutlen = 300 end };
    {'tpope/vim-fugitive'};
    {'tpope/vim-rhubarb'};
    {'tpope/vim-eunuch'};
    {'ggandor/leap.nvim'};

    -- Neotree
    {"nvim-neo-tree/neo-tree.nvim", branch = "v3.x"};
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",

    -- style
    {'junegunn/goyo.vim'};
    {'junegunn/seoul256.vim'};
    'nvim-lualine/lualine.nvim';        -- statusline
    'kyazdani42/nvim-web-devicons';     -- icons for the statusline
    {'edkolev/tmuxline.vim'};
    {'kdheepak/tabline.nvim'};
    --
    {'superevilmegaco/AutoRemoteSync.nvim'};
    -- {'chipsenkbeil/distant.nvim'};
}


-------------------- OPTIONS -------------------------------
-- colors
opt.termguicolors = true
vim.cmd 'colorscheme seoul256'            -- Put your favorite colorscheme here
g.seoul256_background = 237

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

-- -- tab to navigate completion menu
map('i', '<S-Tab>', 'pumvisible() ? "\\<C-p>" : "\\<Tab>"', {expr = true})
map('i', '<Tab>', 'pumvisible() ? "\\<C-n>" : "\\<Tab>"', {expr = true})


-- control h and l to change between buffers
map('n', '<C-h>', '<cmd>bprevious<CR>')
map('n', '<C-l>', '<cmd>bnext<CR>')
map('n', '<C-d>', '<cmd>bdelete<CR>')

-- fzf --
map('n', '<C-p>', '<cmd>Files<CR>')

-- fugitive --
map('n', '<space>g', '<cmd>Git<CR>', {desc = "Git"})

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
local lspconfig = require 'lspconfig'

lspconfig.pylsp.setup {
    -- on_attach = on_attach,
    filetypes = {"python"},
    settings = {
        pyslp = {
            plugins = {
                -- black = { enabled = true },
                -- isort = { enabled = true, profile = "black" },
                -- pycodestyle = {enabled = true},
                pylsp_black = {enabled = true},
                pylsp_isort = {enabled = true},
                ruff = {enabled = true},
                -- disabled standard plugins
                autopep8 = {enabled = false},       -- covered by black
                yapf = {enabled = false},           -- covered by black
                pydocstyle = {enabled = false},
            },
        },
    }
}

vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, {desc = "Open Float"})
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, {desc = "Go to Prev"})
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, {desc = "Go to Next"})
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, {desc = "Open Location List"})

-- local on_attach = function(client, bufnr)
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
    -- local bufopts = { noremap=true, silent=false, buffer=bufnr }
        local bufopts = { buffer = ev.buf }
        bufopts.desc = "Declaration"
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        bufopts.desc = "Definition"
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        bufopts.desc = "References"
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        bufopts.desc = "Rename"
        vim.keymap.set('n', '<space>r', vim.lsp.buf.rename, bufopts)
        bufopts.desc = "Add Workspace Folder"
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        bufopts.desc = "Remove Workspace Folder"
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        bufopts.desc = "List Workspace Folders"
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        bufopts.desc = "Format"
        vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
        bufopts.desc = "Code Action"
        vim.keymap.set({'n','v'}, '<space>c', vim.lsp.buf.code_action, bufopts)
        bufopts.desc = "Hover"
        vim.keymap.set('n', '<leader>h', vim.lsp.buf.hover, bufopts)
        bufopts.desc = "Signature Help"
        vim.keymap.set({'n','i'}, '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.lsp.set_log_level("debug")

        cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.format() ]]
    end,
})
    -- local augroup_id = vim.api.nvim_create_augroup(
    --     "FormatModificationsDocumentFormattingGroup",
    --     { clear = false }
    -- )
    -- vim.api.nvim_clear_autocmds({ group = augroup_id, buffer = bufnr })
    -- vim.api.nvim_create_autocmd(
    --     { "BufWritePre" },
    --     {
    --         group = augroup_id,
    --         buffer = bufnr,
    --         callback = function()
    --             local lsp_format_modifications = require"lsp-format-modifications"
    --             lsp_format_modifications.format_modifications(client, bufnr)
    --         end,
    --     }
    -- )


-- We use the default settings for ccls and pylsp: the option table can stay empty
-- require('lspfuzzy').setup {}  -- Make the LSP client use FZF instead of the quickfix list


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
-- require('distant').setup {
--     -- applies chip's personal settings to every machine you connect to
--     --
--     -- 1. ensures that distant servers terminate with no connections
--     -- 2. provides navigation bindings for remote directories
--     -- 3. provides keybinding to jump into a remote file's parent directory
--     ['*'] = require('distant.settings').chip_default()
-- }


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
wk.setup({
  triggers_nowait = {
    -- marks
    "`",
    "'",
    "g`",
    "g'",
    -- registers
    '"',
    "<c-r>",
    -- spelling
    "z=",
    -- lsp
    "<leader>",
  },
})

wk.register({
  w = {
    name = "workspace", -- optional group name
  },
}, { prefix = "<space>" })


------------------- Neo Tree ------------------------------
g.neo_tree_remove_legacy_commands = 1
map('n', '<leader>nt', '<cmd>Neotree<CR>', {desc = "Neotree"})
map('n', '<leader>nf', '<cmd>Neotree position=float<CR>', {desc = "Neotree Float"})
-- require 'neo-tree'

require('leap').add_default_mappings()

------------------- CMP ------------------------------
-- require 'cmp'.setup({
--     snippet = {
--       -- REQUIRED - you must specify a snippet engine
--       expand = function(args)
--         vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
--         require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
--         -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
--         -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
--       end,
--     },
--     window = {
--       -- completion = cmp.config.window.bordered(),
--       -- documentation = cmp.config.window.bordered(),
--     },
--     mapping = cmp.mapping.preset.insert({
--       ['<C-b>'] = cmp.mapping.scroll_docs(-4),
--       ['<C-f>'] = cmp.mapping.scroll_docs(4),
--       ['<C-Space>'] = cmp.mapping.complete(),
--       ['<C-e>'] = cmp.mapping.abort(),
--       ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
--     }),
--     sources = cmp.config.sources({
--       { name = 'nvim_lsp' },
--       -- { name = 'vsnip' }, -- For vsnip users.
--       { name = 'luasnip' }, -- For luasnip users.
--       -- { name = 'ultisnips' }, -- For ultisnips users.
--       -- { name = 'snippy' }, -- For snippy users.
--     }, {
--         { name = 'buffer' },
--     })
-- })
