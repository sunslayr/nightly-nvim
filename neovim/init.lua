vim.opt.number = true           -- Line numbers
vim.opt.cursorline = true       -- Highlight current line
vim.opt.relativenumber = true   -- Relative line numbers
vim.opt.shiftwidth = 4          -- Number of columns that make up one level of (auto)indentation. 0 = tabstop
vim.opt.softtabstop = 2         -- In Insert mode, pressing the <Tab> key will move the cursor to the
                                --      next soft tab stop, instead of inserting a literal tab.
vim.opt.expandtab = true        -- In Insert mode: Use the appropriate number of spaces to insert a <Tab>
vim.opt.smarttab = true         -- When enabled, the <Tab> key will indent by 'shiftwidth' if the cursor
                                --      is in leading whitespace.
vim.opt.autoindent = true       -- Copy indent from current line when starting a new line
vim.opt.signcolumn = "yes:1"    -- Adds a column for debug info
vim.opt.scrolloff = 10          -- Leave 10 rows below line being edited
vim.opt.sidescrolloff = 8       -- Leave 8 columns before line being edited
vim.g.mapleader = " "           -- Map the leader key
vim.opt.winborder = "rounded"   -- Add a border around dialog boxes
vim.opt.updatetime = 600        -- Set the timout for hover events
vim.opt.colorcolumn = { 80 }    -- A list of screen columns that are highlighted with ColorColumn
-- vim.opt.clipboard:append("unnamedplus")


vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>', { desc = 'Source file' })
vim.keymap.set('n', '<leader>w', ':write<CR>', { desc = 'Write file to disc' })
vim.keymap.set('n', '<leader>q', ':quit<CR>', { desc = 'Quit neovim' })
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, { desc = 'Format file using LSP' })

vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '+y<CR>', { desc = 'Copy from system clipboard' })
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '+d<CR>', { desc = 'Cut from system clipboard' })

vim.keymap.set({ 't' }, '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })
    -- Just in case we run something that needs the <Esc> key
vim.keymap.set({ 't' }, 'C-<Esc>', '<Esc>', { desc = 'Send the escape key to the terminal' })

-- Change diagnostic icons
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = "󰠠 ",
            [vim.diagnostic.severity.INFO] = " ",
        },
    },
})

-- If hooks need to run on install, run this before `vim.pack.add()`
-- To act on install from lockfile, run before very first `vim.pack.add()`
local hooks = function(ev)
    -- Use available |event-data|
    local name, kind = ev.data.spec.name, ev.data.kind
    -- Run build script after plugin's code has changed
    if name == 'blink.cmp' and (kind == 'install' or kind == 'update') then
        local path = ev.data.path
        vim.notify('Building Blink.cmp, please wait...')
        local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = path }):wait()
        if obj.code ~= 0 then
            vim.notify("Cargo Build Failed", vim.log.levels.ERROR)
            print(obj.stdout)
            print(obj.stderr)
        else
            vim.notify('All done!')
        end
    end
end

vim.api.nvim_create_autocmd('PackChanged', { callback = hooks })

-- Add colour schemes
vim.pack.add({
    { src = "https://github.com/folke/tokyonight.nvim" },
})

vim.cmd("colorscheme tokyonight-night")

-- Add lsp plugins
vim.pack.add({
    -- Easy LSP configurations
    { src = "https://github.com/neovim/nvim-lspconfig" },
    -- Autocompletion engine
    { src = "https://github.com/saghen/blink.cmp" },
    -- Tree sitting or smth ig? fr no cap.
    { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

require("blink.cmp").setup({
    keymap = { preset = 'super-tab' },
})

vim.lsp.config('nvim-treesitter', {})

vim.lsp.config('lua_ls', {
    -- Server-specific settings. See `:help lsp-quickstart`
    -- Lets the lua lsp work with nvim api
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = {
                    "vim",
                    "require",
                },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
})

vim.lsp.enable({
    "nvim-treesitter", -- Install clang and cargo install tree-sitter-cli
    "lua_ls",
    "nixd",
    -- "rust_analyzer", -- Obviously you need rust installed
    -- "codebook",
    -- "pylsp",
    -- "bashls",
})
local ts_parsers = {
    'bash',
    'c',
    'cpp',
    'rust',
    'lua',
    'json',
    'vim',
    'vimdoc',
    'python',
    'nix',
}
require('nvim-treesitter').install(ts_parsers)

-- Add file plugins
vim.pack.add({
    --  { src = "https://github.com/nvim-neo-tree/neo-tree.nvim" },
    { src = "https://github.com/nvim-mini/mini.pick" },
    { src = "https://github.com/stevearc/oil.nvim" },
})

require("mini.pick").setup()
require("oil").setup({
    keymaps = {
        ["<C-s>"] = { "actions.select", opts = { vertical = true } },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true } },
    },
    view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
    },

})

vim.keymap.set('n', '<leader>O', ':Oil<CR>') -- Open Oil file browser

-- Add general plugins
vim.pack.add({
    { src = "https://github.com/nvim-mini/mini.nvim" }, -- A bunch of tiny plugins
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/folke/which-key.nvim" },
    -- Complete control of the undo tree
    { src = "https://github.com/jiaoshijie/undotree" },
    -- Create and control multiple terminals
    { src = "https://github.com/akinsho/toggleterm.nvim" },
})

-- nvim-mini plugins
require('mini.comment').setup({})
require('mini.animate').setup({})
require('mini.indentscope').setup({})
require('mini.trailspace').setup({})
require('mini.notify').setup({})
require('mini.pairs').setup({})
require('mini.pick').setup({})
require('mini.extra').setup({})
require('mini.icons').setup({})
require('mini.sessions').setup({})
require('mini.move').setup({
    mappings = {
        -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
        left = '<M-Left>',
        right = '<M-Right>',
        up = '<M-Up>',
        down = '<M-Down>',
        -- Move current line in Normal mode
        line_left = '<M-Left>',
        line_right = '<M-Right>',
        line_up = '<M-Up>',
        line_down = '<M-Down>',
    }
})

vim.keymap.set(
    'n', '<leader>ff', ':Pick files<CR>',
    { desc = 'Open pick file picker' }
)
vim.keymap.set(
    'n', '<leader>fb', ':Pick buffers<CR>',
    { desc = 'Open pick buffer picker' }
)
vim.keymap.set(
    "n", "<leader>fs",
    function() MiniSessions.select() end, { desc = "Select session" }
)
vim.keymap.set(
    "n", "<leader>fd",
    function() MiniSessions.select("delete") end, { desc = "Select session to delete" }
)
vim.keymap.set('n', '<leader>ss',
    function() MiniSessions.write(vim.fn.fnamemodify(vim.fn.getcwd(), ':t'), {}) end,
    { desc = "Quick save session" }
)
vim.keymap.set(
    'n', '<leader>sS',
    function() MiniSessions.write(vim.fn.input('Name: ')) end,
    { desc = 'Save session with name' }
)

require('lualine').setup({})
require('which-key').setup({})
require('undotree').setup({})
require('toggleterm').setup({})

vim.keymap.set(
    'n', '<leader>u', require('undotree').toggle,
    { noremap = true, silent = true, desc = "Toggle undotree" }
)
vim.keymap.set(
    'n', '<leader>st', ':ToggleTerm size=10 direction=horizontal<CR>',
    { desc = 'Open mini split terminal' }
)

-- Auto Commands
-- Restore last cursor position when re-opening a file
local last_cursor_group = vim.api.nvim_create_augroup("LastCursorGroup", {})
vim.api.nvim_create_autocmd("BufReadPost", {
    group = last_cursor_group,
    callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        local lcount = vim.api.nvim_buf_line_count(0)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
})

-- Highlight yanked text for 200ms
local highlight_yank_group = vim.api.nvim_create_augroup("HighlightYank", {})
vim.api.nvim_create_autocmd("TextYankPost", {
    group = highlight_yank_group,
    pattern = "*",
    callback = function()
        vim.hl.on_yank({
            higroup = "IncSearch",
            timeout = 200,
        })
    end,
})

-- Open diagnostic message on hover
vim.api.nvim_create_autocmd({ "CursorHold" }, {
    pattern = "*",
    callback = function()
        for _, winid in pairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.api.nvim_win_get_config(winid).zindex then
                return
            end
        end
        vim.diagnostic.open_float({
            scope = "cursor",
            focusable = false,
            close_events = {
                "CursorMoved",
                "CursorMovedI",
                "BufHidden",
                "InsertCharPre",
                "WinLeave",
            },
        })
    end
})

-- Keymap for using LSP server
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
        vim.keymap.set("n", "gR", function() MiniExtra.pickers.lsp({ scope = 'references' }) end,
            { desc = 'Show LSP references' })
        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = 'Go to declaration' })
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = 'Go to definition' })
        vim.keymap.set("n", "gi", function() MiniExtra.pickers.lsp({ scope = 'implementation' }) end,
            { desc = 'Show LSP implementations' })
        vim.keymap.set("n", "gt", function() MiniExtra.pickers.lsp({ scope = 'definition' }) end,
            { desc = 'Show LSP type definitions' })
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = 'See available code actions' })
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, { desc = 'Smart rename' })
        vim.keymap.set("n", "<leader>D", function() MiniExtra.pickers.diagnostic({ scope = 'current' }) end,
            { desc = 'Show diagnostics' })
    end
})
