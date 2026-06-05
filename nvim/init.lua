local g = vim.g
local opt = vim.opt

g.mapleader = "\\"

local function map(mode, lhs, rhs, opts)
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend("force", { noremap = true }, opts or {}))
end

local augroup = function(name)
    return vim.api.nvim_create_augroup("michael." .. name, { clear = true })
end

-------------------- PLUGINS -------------------------------
local gh = function(repo)
    return "https://github.com/" .. repo
end

local cb = function(repo)
    return "https://codeberg.org/" .. repo
end

vim.api.nvim_create_autocmd("PackChanged", {
    group = augroup("pack"),
    callback = function(ev)
        if ev.data.spec.name == "nvim-treesitter" and (ev.data.kind == "install" or ev.data.kind == "update") then
            vim.cmd.packadd("nvim-treesitter")
            vim.cmd("TSUpdate")
        end
    end,
})

vim.pack.add({
    -- Utils
    gh("nvim-lua/plenary.nvim"),
    gh("MunifTanjim/nui.nvim"),
    gh("stevearc/dressing.nvim"),

    { src = gh("L3MON4D3/LuaSnip"), version = vim.version.range("2") }, -- Snippets plugin
    gh("lervag/vimtex"),

    -- Treesitter
    gh("nvim-treesitter/nvim-treesitter"),
    gh("nvim-treesitter/nvim-treesitter-context"),
    gh("nvim-treesitter/nvim-treesitter-textobjects"),

    -- Telescope
    gh("nvim-telescope/telescope.nvim"),
    gh("SuperBo/fugit2.nvim"),
    gh("chrisgrieser/nvim-tinygit"),
    gh("sindrets/diffview.nvim"),

    -- motions and ux
    gh("numToStr/Comment.nvim"),
    gh("folke/which-key.nvim"),
    gh("folke/zen-mode.nvim"),
    gh("tpope/vim-fugitive"),
    gh("tpope/vim-rhubarb"),
    gh("tpope/vim-eunuch"),
    cb("andyg/leap.nvim"),

    -- Neotree
    { src = gh("nvim-neo-tree/neo-tree.nvim"), version = "v3.x" },

    -- style
    gh("junegunn/seoul256.vim"),

    gh("nvim-lualine/lualine.nvim"),        -- statusline
    gh("nvim-tree/nvim-web-devicons"),      -- icons for the statusline
    gh("edkolev/tmuxline.vim"),
    gh("kdheepak/tabline.nvim"),

    -- Functionality
    gh("neovim/nvim-lspconfig"),           -- LSP server configurations for vim.lsp.config()
    gh("stevearc/conform.nvim"),
    gh("folke/trouble.nvim"),
}, { load = true, confirm = false })


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
opt.pumheight = 12                  -- Completion menu height
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
opt.wildmode = { "list", "longest" } -- Command-line completion mode
opt.wrap = false                    -- Disable line wrap
opt.autocomplete = true             -- Built-in automatic completion
opt.complete = { ".^5", "w^5", "b^5", "u^5" }
opt.completeopt = { "menuone", "noselect", "popup" }


-------------------- MAPPINGS ------------------------------

map('i', 'jj', '<Esc>', { desc = "Exit insert mode" })
map('n', ';;', '<cmd>w<CR>', { desc = "Write buffer" })
map('n', '<Esc>', '<cmd>noh<CR>', { desc = "Clear search highlight" })

map('i', '<Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true, desc = "Next completion item" })
map('i', '<S-Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true, desc = "Previous completion item" })
map('i', '<C-Space>', function()
    vim.lsp.completion.get()
end, { desc = "Trigger LSP completion" })

-- control h and l to change between buffers
map('n', '<C-h>', '<cmd>bprevious<CR>', { desc = "Previous buffer" })
map('n', '<C-l>', '<cmd>bnext<CR>', { desc = "Next buffer" })
map('n', '<C-d>', '<cmd>bdelete<CR>', { desc = "Delete buffer" })

-- show current path --
map('n', '<leader>p', '<cmd>echo expand("%:p")<CR>', {desc = "Show current path"})
map("n", "<leader>?", function()
    require("which-key").show({ global = false })
end, { desc = "Buffer Local Keymaps (which-key)" })

-------------------- COMMENT -------------------------------
require('Comment').setup()

-------------------- Fugit2 -------------------------------
require("fugit2").setup({
    width = 100,
})

map('n', '<leader>gg', '<cmd>Fugit2<CR>', {desc = "Fugit2"})

-------------------- Zen Mode -------------------------------
require("zen-mode").setup({
    window = {
        options = {
            wrap = true,
            linebreak = true,
            breakindent = true,
        },
    },
})

-------------------- TREE-SITTER ---------------------------
local treesitter_languages = { "python", "markdown", "lua" }
local treesitter = require("nvim-treesitter")
local installed_treesitter_parsers = treesitter.get_installed("parsers")
local missing_treesitter_parsers = vim.tbl_filter(function(lang)
    return not vim.list_contains(installed_treesitter_parsers, lang)
end, treesitter_languages)

if #missing_treesitter_parsers > 0 then
    treesitter.install(missing_treesitter_parsers)
end

vim.api.nvim_create_autocmd("FileType", {
    group = augroup("treesitter"),
    pattern = treesitter_languages,
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- do folds
opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

require('treesitter-context').setup({
    multiline_threshold = 5,
})

-------------------- LSP -----------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
    group = augroup("lsp"),
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        local opts = { buffer = ev.buf }

        if client and client:supports_method("textDocument/completion") then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end

        map({ "n", "x" }, "gq", function()
            vim.lsp.buf.format({ async = true })
        end, vim.tbl_extend("force", opts, { desc = "Format" }))

        map("n", "grt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "Go to Type Definition" }))
        map("n", "grd", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to Declaration" }))
        map("n", "grr", "<cmd>Telescope lsp_references<CR>", vim.tbl_extend("force", opts, { desc = "Go to References" }))
        map("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to Definition" }))
    end,
})

vim.lsp.enable({
    'autotools_ls',
    'ruff',
    'ty',
})


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
vim.g['tmuxline_theme'] = 'vim_statusline_3'

require 'nvim-web-devicons'.setup()

-------------------- Tabline --------------------------------
require 'tabline'.setup {
    enable = true,
    options = {
        section_separators = {'', ''},
        component_separators = {'', ''},
        show_devicons = true,
        show_filename_only = true,
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

------------------- Leap ------------------------------
local leap = require('leap')
map({'n', 'x', 'o'}, 's', '<Plug>(leap)', {desc = "Leap" })
map('n',             'S', '<Plug>(leap-from-window)', {desc = "Leap from Window" })
leap.opts.preview = function (ch0, ch1, ch2)
  return not (
    ch1:match('%s')
    or (ch0:match('%a') and ch1:match('%a') and ch2:match('%a'))
  )
end

-- Define equivalence classes for brackets and quotes, in addition to
-- the default whitespace group:
leap.opts.equivalence_classes = {
  ' \t\r\n', '([{', ')]}', '\'"`'
}

-- Use the traversal keys to repeat the previous motion without
-- explicitly invoking Leap:
require('leap.user').set_repeat_keys('<enter>', '<backspace>')

------------------- Telescope ------------------------------
local builtin = require('telescope.builtin')
map('n', '<leader>ff', builtin.find_files, {desc="Find Files"})
map('n', '<leader>fg', builtin.live_grep, {desc="Live Grep"})
map('n', '<leader>fb', builtin.buffers, {desc="Find Buffers"})
map('n', '<leader>fh', builtin.help_tags, {desc="Find Help Tags"})
map('n', '<leader>fs', builtin.grep_string, {desc="Grep String under Cursor"})
map('n', '<leader>f;', builtin.jumplist, {desc="Find Jumplist"})
map('n', '<leader>f/', builtin.current_buffer_fuzzy_find, {desc="Current Buffer Fuzzy Find"})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopePrompt",
  callback = function()
    vim.opt_local.autocomplete = false
  end,
})

---- Diffview ---
require("diffview").setup({
    keymaps = {
        file_panel = {
            {
                "n", "cc",
                function()
                    vim.ui.input({ prompt = "Commit message: " }, function(msg)
                        if not msg then return end
                        local results = vim.system({ "git", "commit", "-m", msg }, { text = true }):wait()

                        if results.code ~= 0 then
                            vim.notify(
                                "Commit failed with the message: \n"
                                .. vim.trim(results.stdout .. "\n" .. results.stderr),
                                vim.log.levels.ERROR,
                                { title = "Commit" }
                            )
                        else
                            vim.notify(results.stdout, vim.log.levels.INFO, { title = "Commit" })
                        end
                    end)
                end,
                { desc = "Create commit" },
            },
            {
                "n", "ca",
                "<Cmd>Git commit --amend <bar> wincmd J<CR>",
                { desc = "Amend the last commit" },
            },
            {
                "n", "gf",
                function()
                    require("diffview.actions").goto_file()
                    vim.cmd('tabclose #')
                end,
                { desc = "Open file and close Diffview tab" },
            },
        },
    },
})

map('n', '<leader>dd', '<cmd>DiffviewOpen<CR>', {desc = "Diffview Open"})
map('n', '<leader>dx', '<cmd>DiffviewClose<CR>', {desc = "Diffview Close"})

---- Trouble ---
map('n', '<leader>x', '<cmd>Trouble diagnostics toggle filter.buf=0 focus=true<CR>', {desc = "Buffer Diagnostics (Trouble)"})
map('n', '<leader>cs', '<cmd>Trouble symbols toggle focus=false win.position=left<CR>', {desc = "Symbols (Trouble)"})
map('n', '<leader>cl', '<cmd>Trouble lsp toggle focus=false win.position=left<CR>', {desc = "LSP Definitions / references / ... (Trouble)"})
map('n', '<leader>l', '<cmd>Trouble loclist toggle<CR>', {desc = "Location List (Trouble)"})
map('n', '<leader>q', '<cmd>Trouble qflist toggle<CR>', {desc = "Quickfix List (Trouble)"})

require("trouble").setup({
    modes = {
        diagnostics_buffer = {
            mode = "diagnostics",
            filter = { buf = 0 },
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
