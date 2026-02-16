-- ============================================================================
-- LEADER KEY
-- ============================================================================
vim.g.mapleader = " "

-- ============================================================================
-- LAZY.NVIM BOOTSTRAP
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGINS CONFIGURATION
-- ============================================================================
require("lazy").setup({

    -- Theme
    {
        "RRethy/nvim-base16",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("base16-darcula")
        end
    },

    -- Lualine (Custom Interface)
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        lazy = false,
        priority = 900,
        config = function()
            local lualine = require('lualine')
            local conditions = {
                is_buffer_named = function()
                    return vim.fn.empty(vim.fn.expand('%:t')) ~= 1
                end,
                is_wide_window = function()
                    return vim.fn.winwidth(0) > 80
                end,
                is_git_workspace = function()
                    local filepath = vim.fn.expand('%:p:h')
                    local gitdir = vim.fn.finddir('.git', filepath .. ';')
                    return gitdir and #gitdir > 0 and #gitdir < #filepath
                end,
            }

            local components = {
                mode = {
                    function() return vim.fn.mode() end,
                    padding = { left = 1, right = 1 },
                    color = { gui = 'bold' }
                },
                filename = {
                    'filename',
                    path = 1,
                    symbols = { modified = ' ●', readonly = ' ', unnamed = '[No Name]' },
                    color = { gui = 'bold' },
                    cond = conditions.is_buffer_named
                },
                diagnostics = {
                    'diagnostics',
                    sources = { 'nvim_diagnostic' },
                    sections = { 'error', 'warn', 'info', 'hint' },
                    symbols = { error = ' ', warn = ' ', info = ' ' },
                    colored = true,
                    always_visible = false
                },
                lsp_client = {
                    function()
                        local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
                        if #buf_clients == 0 then return 'No LSP' end
                        local client_names = {}
                        for _, client in pairs(buf_clients) do
                            table.insert(client_names, client.name)
                        end
                        return ' ' .. table.concat(client_names, ', ')
                    end,
                    color = { gui = 'bold' },
                    cond = conditions.is_wide_window,
                },
                git = {
                    'branch',
                    icon = '',
                    color = { gui = 'bold' },
                    cond = conditions.is_git_workspace
                },
                diff = {
                    'diff',
                    symbols = { added = '󰐖 ', modified = '󰏫 ', removed = '≠ ' },
                    colored = true,
                    cond = conditions.is_wide_window
                },
                filetype = {
                    'filetype',
                    icon_only = true,
                    padding = { left = 1, right = 0 }
                },
                fileformat = {
                    'fileformat',
                    symbols = { unix = ' ', dos = ' ', mac = ' ' },
                    color = { gui = 'bold' }
                },
                location = {
                    'location',
                    padding = { left = 0, right = 1 },
                    color = { gui = 'bold' }
                },
                encoding = {
                    'encoding',
                    color = { gui = 'bold' },
                    cond = conditions.is_wide_window
                },
                scroll_bar = {
                    function()
                        local current_line = vim.fn.line('.')
                        local total_lines = vim.fn.line('$')
                        local chars = {'▁', '▂', '▃', '▄', '▅', '▆', '▇', '█'}
                        local index = math.floor((current_line - 1) / total_lines * #chars) + 1
                        return chars[index]
                    end,
                    padding = { left = 0, right = 0 },
                    color = { gui = 'bold' },
                },
            }

            lualine.setup({
                options = {
                    icons_enabled = true,
                    theme = 'auto',
                    component_separators = { left = '', right = '' },
                    section_separators = { left = '', right = '' },
                    globalstatus = true,
                },
                sections = {
                    lualine_a = { components.mode },
                    lualine_b = { components.filename },
                    lualine_c = { components.git, components.diff, components.diagnostics },
                    lualine_x = { components.lsp_client, components.filetype, components.encoding, components.fileformat },
                    lualine_y = { components.location },
                    lualine_z = { components.scroll_bar },
                },
                inactive_sections = {
                    lualine_b = { components.filename },
                    lualine_x = { 'location' }
                },
            })
        end,
    },

    -- Fzf Lua (File search)
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require('fzf-lua').register_ui_select()
        end,
		options = {
			path_shorten = true,
			fd_opts =  [[ --exclude 'bin' --exclude 'build' --exclude '.git' --exclude '.venv']]
		},
        keys = {
            { "<c-f>", mode = "n", function() require("fzf-lua").files() end, desc = "Fzf files" },
            { "<c-b>", mode = "n", function() require("fzf-lua").buffers() end, desc = "Fzf buffers" },
            { "<c-g>", mode = "n", function() require("fzf-lua").live_grep() end, desc = "Fzf grep" }
        },
    },

    -- Oil (File Explorer)
    {
        "stevearc/oil.nvim",
        lazy = false,
        config = function()
            require("oil").setup({
                keymaps = {
                    ["gt"] = "actions.open_terminal",
                    ["g."] = "actions.toggle_hidden"
                }
            })
            vim.g.loaded_netrw = 1
            vim.g.loaded_netrw_Plugin = 1
        end,
        keys = {
            { "-", mode = "n", function() require("oil").open(nil) end, desc = "Oil file manager" }
        },
        dependencies = { "nvim-tree/nvim-web-devicons" },
    },

    -- LSP Config
    {
        'neovim/nvim-lspconfig',
        lazy = false,
        dependencies = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'hrsh7th/cmp-nvim-lsp',
        },
        init = function()
            vim.opt.signcolumn = 'yes'
        end,
        config = function()
            require('mason').setup()

            local servers = {
                'asm_lsp', 'bashls', 'awk_ls', 'hls', 'ocamllsp', 'lua_ls',
                'rust_analyzer', 'clangd', 'gopls', 'jdtls', 'emmet_ls',
                'ts_ls', 'phpactor', 'pyright', 'lemminx', 'texlab'
            }

            local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "🛈" }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end

            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = {buffer = event.buf}
                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                    vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
                    vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                    vim.keymap.set('n', '<leader>i', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
                end,
            })

            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            require('mason-lspconfig').setup({
                ensure_installed = servers,
                handlers = {
                    function(server_name)
                        require('lspconfig')[server_name].setup({
                            capabilities = capabilities
                        })
                    end,
                }
            })
        end
    },

    -- Nvim-cmp (Autocompletion)
    {
        'hrsh7th/nvim-cmp',
        event = 'InsertEnter',
        dependencies = {
            'hrsh7th/cmp-buffer',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
            'onsails/lspkind.nvim'
        },
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')
            require('luasnip.loaders.from_vscode').lazy_load()

            cmp.setup({
                sources = cmp.config.sources({
                    {name = 'nvim_lsp'},
                    {name = 'luasnip'}
                }, {
                    {name = 'buffer'}
                }),
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered()
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({select = false}),
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),

                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ['<S-Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ['<C-f>'] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ['<C-b>'] = cmp.mapping(function(fallback)
                        if luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                }),
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end
                },
                formatting = {
                    fields = {'abbr', 'kind', 'menu'},
                    format = require('lspkind').cmp_format({
                        mode = 'symbol',
                        maxwidth = 50,
                        ellipsis_char = '...'
                    })
                },
            })
        end
    },

    -- Copilot
    {
        'github/copilot.vim',
        lazy = false,
        config = function()
            vim.g.copilot_no_tab_map = true
            vim.g.copilot_assume_mapped = true
            vim.cmd("imap <silent><script><expr> <C-l> copilot#Accept('\\<CR>')")
        end
    },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        config = function()
            require('nvim-treesitter.configs').setup({
                highlight = { enable = true },
                indent = {
                    disable = { 'bash', 'haskell' },
                    enable = true
                },
                additional_vim_regex_highlighting = false,
                ensure_installed = {
                    'bash', 'awk', 'regex', 'make', 'toml', 'xml', 'markdown',
                    'markdown_inline', 'vim', 'vimdoc', 'yaml', 'query', 'c',
                    'cpp', 'go', 'gomod', 'gowork', 'gosum', 'lua', 'luadoc',
                    'luap', 'python', 'ocaml', 'haskell', 'r', 'rust', 'zig',
                    'java', 'html', 'css', 'javascript', 'jsdoc', 'json',
                    'typescript', 'tsx', 'php', 'sql'
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<space>',
                        node_incremental = '<space>',
                        scope_incremental = false,
                        node_decremental = '<backspace>'
                    }
                },
            })
        end,
    },

    -- Treesitter textobjects & endwise
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        lazy = false,
        dependencies = { 'nvim-treesitter/nvim-treesitter' }
    },
    {
        'RRethy/nvim-treesitter-endwise',
        config = function()
            require('nvim-treesitter.configs').setup({ endwise = { enable = true } })
        end,
        ft = { 'lua', 'ruby', 'vimscript', 'sh', 'elixir', 'fish', 'julia', 'xml' },
        dependencies = 'nvim-treesitter/nvim-treesitter'
    },

    -- Colorizer
    {
        'NvChad/nvim-colorizer.lua',
        config = true,
        ft = { 'vim', 'lua', 'html', 'css', 'js', 'php', 'scss', 'dosini', 'xml' }
    },

    -- Haskell Indent
    { 'itchyny/vim-haskell-indent', ft = 'haskell' },

	-- Nix Indent
    { 'LnL7/vim-nix', ft = 'nix' },

    -- Autopairs & Autotag
    {
        'windwp/nvim-autopairs',
        event = { 'InsertEnter', 'CmdlineEnter' },
        config = function()
            require('nvim-autopairs').setup({
                enable_check_bracket_line = false,
                ignored_next_char = "[%w%.]"
            })
        end
    },
    {
        'windwp/nvim-ts-autotag',
        config = true,
        ft = { 'html', 'css', 'php', 'xml', 'js' },
        dependencies = 'nvim-treesitter/nvim-treesitter'
    },
    {
        'andymass/vim-matchup',
        lazy = false,
        dependencies = 'nvim-treesitter/nvim-treesitter',
        config = function()
            vim.g.matchup_surround_enabled = 1
            vim.g.matchup_transmute_enabled = 1
            vim.g.matchup_delim_stopline = 43
            require('nvim-treesitter.configs').setup({ matchup = { enable = true } })
        end
    },

    -- Editing tools (Comment, Surround, Substitute, Lion, Undotree)
    {
        'numToStr/Comment.nvim',
        opts = {},
        keys = { 'gc', 'gb', { 'gc', mode = 'x' }, { 'gb', mode = 'x' } }
    },
    {
        'kylechui/nvim-surround',
        version = '*',
        config = true,
        keys = { 'cs', 'ds', 'ys', { 'S', mode = 'x' } }
    },
    {
        'gbprod/substitute.nvim',
        opts = {},
        keys = {
            { 's',  mode = 'n', function() require('substitute').operator() end, desc = 'Substitute' },
            { 'ss', mode = 'n',  function() require('substitute').line() end, desc = 'Substitute line' },
            { 'S',  mode = 'n',  function() require('substitute').eol() end, desc = 'Substitute to end of line' },
            { 's',  mode = 'x',  function() require('substitute').visual() end, desc = 'Substitute visual' },
            { 'sx',  mode ='n', function() require('substitute.exchange').operator() end, desc = 'Exchange' },
            { 'sxx', mode ='n', function() require('substitute.exchange').line() end, desc = 'Exchange line' },
            { 'X',   mode ='x', function() require('substitute.exchange').visual() end, desc = 'Exchange visual' },
            { 'sxc', mode ='n', function() require('substitute.exchange').cancel() end, desc = 'Exchange cancel' },
        },
    },
    {
        'tommcdo/vim-lion',
        init = function() vim.g.lion_squeeze_spaces = 1 end,
        keys = {
			{ 'gl', mode = { 'n', 'x' } },
			{ 'gL', mode = { 'n', 'x' } }
		}
    },
    {
        'mbbill/undotree',
        init = function()
            vim.g.undotree_ShortIndicators = 1
            vim.g.undotree_SetFocusWhenToggle = 1
            vim.g.undotree_WindowLayout = 3
        end,
        keys = {
            { '<leader>u', mode = 'n', vim.cmd.UndotreeToggle, desc = 'Undo tree' }
        }
    },

    -- Harpoon & Gitsigns
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
        opts = {},
        keys = {
            { '<leader>a', mode = 'n', function() require('harpoon'):list():add() end, desc = 'Harpoon add' },
            { '<leader>e', mode = 'n', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = 'Harpoon quick-menu' },
            { '<leader>1', mode = 'n', function() require('harpoon'):list():select(1) end, desc = 'Harpoon select 1' },
            { '<leader>2', mode = 'n', function() require('harpoon'):list():select(2) end, desc = 'Harpoon select 2' },
            { '<leader>3', mode = 'n', function() require('harpoon'):list():select(3) end, desc = 'Harpoon select 3' },
            { '<leader>4', mode = 'n', function() require('harpoon'):list():select(4) end, desc = 'Harpoon select 4' },
        },
    },
    {
        'lewis6991/gitsigns.nvim',
        event = 'BufEnter',
        opts = {
            on_attach = function(bufnr)
                local gitsigns = require('gitsigns')
                local function map(mode, l, r, opts)
                    opts = opts or {}
                    opts.buffer = bufnr
                    vim.keymap.set(mode, l, r, opts)
                end

                -- Navigation
                map('n', ']c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({']c', bang = true})
                    else
                        gitsigns.nav_hunk('next')
                    end
                end, { desc = 'Next Git hunk' })

                map('n', '[c', function()
                    if vim.wo.diff then
                        vim.cmd.normal({'[c', bang = true})
                    else
                        gitsigns.nav_hunk('prev')
                    end
                end, { desc = 'Previous Git hunk' })

                -- Actions (Normal mode)
                map('n', '<leader>gs', gitsigns.stage_hunk, { desc = 'Git stage hunk' })
                map('n', '<leader>gr', gitsigns.reset_hunk, { desc = 'Git reset hunk' })
                map('n', '<leader>gS', gitsigns.stage_buffer, { desc = 'Git stage buffer' })
                map('n', '<leader>gu', gitsigns.undo_stage_hunk, { desc = 'Git undo stage hunk' })
                map('n', '<leader>gR', gitsigns.reset_buffer, { desc = 'Git reset buffer' })
                map('n', '<leader>gp', gitsigns.preview_hunk, { desc = 'Preview Git hunk' })
                map('n', '<leader>gb', function() gitsigns.blame_line{full=true} end, { desc = 'Git blame line' })
                map('n', '<leader>gd', gitsigns.diffthis, { desc = 'Git diff against index' })
                map('n', '<leader>gD', function() gitsigns.diffthis('~') end, { desc = 'Git diff against last commit' })

                -- Actions (Visual mode)
                map('v', '<leader>gs', function()
                    gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')}
                end, { desc = 'Git stage selected lines' })
                map('v', '<leader>gr', function()
                    gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')}
                end, { desc = 'Git reset selected lines' })

                -- Toggles
                map('n', '<leader>gtb', gitsigns.toggle_current_line_blame, { desc = 'Toggle Git blame inline' })
                map('n', '<leader>gtd', gitsigns.toggle_deleted, { desc = 'Toggle Git deleted lines inline' })

                -- Text object (Allows you to use operations like 'dih' or 'cih' on a git hunk)
                map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select Git hunk' })
            end
        }
    },

    -- Which-Key
    {
        'folke/which-key.nvim',
        event = 'VeryLazy',
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },

    -- Smart Splits (Window management)
    {
        'mrjones2014/smart-splits.nvim',
        opts = { cursor_follows_swapped_bufs = true },
        keys = {
            { '<c-k>', mode = 'n', function() require('smart-splits').move_cursor_up()    end, desc = 'Move up' },
            { '<c-j>', mode = 'n', function() require('smart-splits').move_cursor_down()  end, desc = 'Move down' },
            { '<c-h>', mode = 'n', function() require('smart-splits').move_cursor_left()  end, desc = 'Move left' },
            { '<c-l>', mode = 'n', function() require('smart-splits').move_cursor_right() end, desc = 'Move right' },
            { '<a-k>', mode = 'n', function() require('smart-splits').swap_buf_up()       end, desc = 'Swap up' },
            { '<a-j>', mode = 'n', function() require('smart-splits').swap_buf_down()     end, desc = 'Swap down' },
            { '<a-h>', mode = 'n', function() require('smart-splits').swap_buf_left()     end, desc = 'Swap left' },
            { '<a-l>', mode = 'n', function() require('smart-splits').swap_buf_right()    end, desc = 'Swap right' },
            { '<a-r>', mode = 'n', function() require('smart-splits').start_resize_mode() end, desc = 'Resize mode' },
        },
    },

    -- Auto-Session & Zen Mode & REPL
    {
        'rmagatti/auto-session',
        dependencies = { 'ibhagwan/fzf-lua' },
        lazy = false,
        init = function()
            vim.o.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
        end,
        opts = {
            suppressed_dirs = { '~/', '/' },
            auto_create = false,
            use_git_branch = true
        },
        keys = {
            { '<leader>sf', mode = 'n', '<cmd>AutoSession search<cr>', desc = "Find session" },
            { '<leader>ss', mode = 'n', '<cmd>AutoSession save<cr>',   desc = "Save session" },
        },
    },
    {
        'folke/zen-mode.nvim',
        opts = {},
        keys = {
            { '<leader>z', mode = 'n', function() require('zen-mode').toggle({window = {width = 120} }) end, desc = 'Toggle Zen Mode' }
        }
    },
    {
        'milanglacier/yarepl.nvim',
        config = function()
            require('yarepl').setup({ wincmd = 'vertical topleft 80 split' })
        end,
        keys = {
            { '<leader>rs', mode = 'n', '<cmd>REPLStart<cr>', desc = 'REPL Start' },
			{ '<leader>re', mode = 'x', '<cmd>REPLSendVisual<cr>', desc = 'REPL execute visual selection'},
			{ '<leader>re', mode = 'n', '<cmd>REPLSendLine<cr>j', desc = 'REPL execute line'},
            { '<leader>rx', mode = 'n', '<cmd>REPLClose<cr>', desc = 'REPL close' }
        }
    },

})

-- ============================================================================
-- SETTING
-- ============================================================================
vim.opt.fileencoding = "utf-8"
vim.opt.clipboard = "unnamedplus"

-- Interface
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.title = true
vim.opt.shortmess = 'a'
vim.opt.lazyredraw = true
vim.opt.scrolloff = 4
vim.opt.cursorline = true

-- Default Indentation
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

-- Line Wrapping
vim.opt.wrap = true
vim.opt.breakindent = true
vim.opt.showbreak = '↳ '

-- Windows (Splits)
vim.opt.equalalways = false
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.infercase = true

-- Save and History
vim.opt.backup = false
vim.opt.swapfile = false
vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.undolevels = 5000
vim.opt.undofile = true
vim.opt.autoread = true

-- Theme (Base Transparency)
vim.cmd('hi Normal guibg=NONE ctermbg=NONE')
vim.opt.termguicolors = true
vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })

-- ============================================================================
-- AUTOCMDS
-- ============================================================================

-- Haskell
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
    pattern = '*.hs',
    callback = function()
        vim.opt.expandtab = true
        vim.opt.smartindent = true
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end
})

-- C-like languages and others
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
    pattern = {
        '*.c', '*.cpp','*.h','*.hpp',
        '*.lua', '*.js','*.php',
        '*.rdf', '*.rdfs', '*.ttl', '*.n3', '*.owl',
        '*.sh', '.y', '.yy', '.l', '.ll'
    },
    callback = function()
        vim.opt.expandtab = false
        vim.opt.cindent = true
        vim.opt.tabstop = 4
        vim.opt.shiftwidth = 4
    end
})

-- Web (HTML/CSS)
vim.api.nvim_create_autocmd({'BufEnter', 'BufWinEnter'}, {
    pattern = { '*.html', '*.css'},
    callback = function()
        vim.opt.expandtab = false
        vim.opt.tabstop = 2
        vim.opt.shiftwidth = 2
    end
})

-- Remove trailing spaces before saving
vim.api.nvim_create_autocmd('BufWritePre', {
    desc = 'Remove trailing spaces',
    callback = function()
        vim.cmd([[%s/\s\+$//e]])
    end
})

-- Highlight on yank (copy)
vim.api.nvim_create_autocmd({ "TextYankPost" }, {
    pattern = { "*" },
    callback = function()
        vim.highlight.on_yank({ timeout = 300 })
    end
})

-- ============================================================================
-- KEYBINDINGS (Global Shortcuts)
-- ============================================================================
local opt = { noremap = true, silent = true }

-- Basics
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<esc>', '<cmd>noh<cr>', { noremap = true })
vim.keymap.set('n', '<leader>x', '<cmd>!chmod +x %<cr>')
vim.keymap.set('n', '<c-a>', 'ggVG')
vim.keymap.set('n', '<c-w>', ':w<cr>')
vim.keymap.set('t', '<esc>', '<c-\\><c-n>')

-- Windows (Manual fallback)
vim.keymap.set("n", "<Leader>v", "<C-w>v", opt)
vim.keymap.set("n", "<Leader>s", "<C-w>s", opt)
vim.keymap.set('n', '<Leader>t', ':vs |:terminal<cr>', opt)
vim.keymap.set('n', '<Leader>c', ':close<cr>', opt)

-- Smart jump (Visual lines)
vim.keymap.set("n", "j", [[v:count ? "j" : "gj"]], { noremap = true, expr = true })
vim.keymap.set("n", "k", [[v:count ? "k" : "gk"]], { noremap = true, expr = true })

-- Center screen
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('i', '<esc>', '<esc>l')

