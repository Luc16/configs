local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug('doums/darcula')
Plug('kyazdani42/nvim-tree.lua')
Plug('kyazdani42/nvim-web-devicons')
Plug('akinsho/bufferline.nvim')
Plug('nvim-lualine/lualine.nvim')
Plug('Pocco81/auto-save.nvim')
Plug('nvim-treesitter/nvim-treesitter')
Plug('neovim/nvim-lspconfig')             -- Core LSP configuration
Plug('williamboman/mason.nvim')          -- "App store" for LSPs
Plug('williamboman/mason-lspconfig.nvim') -- Bridge between Mason and lspconfig
Plug('hrsh7th/nvim-cmp')          -- The autocompletion engine
Plug('hrsh7th/cmp-nvim-lsp')      -- LSP source for nvim-cmp
Plug('hrsh7th/cmp-buffer')        -- Buffer text source for nvim-cmp
Plug('hrsh7th/cmp-path')          -- File path source for nvim-cmp
Plug('L3MON4D3/LuaSnip')          -- Snippet engine
Plug('saadparwaiz1/cmp_luasnip')  -- Snippet source for nvim-cmp
Plug('rafamadriz/friendly-snippets') -- A good collection of snippets
Plug('nvim-lua/plenary.nvim')
Plug('nvim-telescope/telescope.nvim')
Plug("zbirenbaum/copilot.lua")
Plug("zbirenbaum/copilot-cmp")
Plug('rmagatti/auto-session')
Plug('unblevable/quick-scope')
Plug('psliwka/vim-smoothie')

vim.cmd [[
  Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }
  Plug 'akinsho/toggleterm.nvim'
]]

vim.call('plug#end')

local home = os.getenv("HOME")
package.path = home .. "/.config/nvim/lua/?.lua;" .. package.path

require("theme")
require("common")
require("keymaps")
require("vimtree")
require("bufferline_config")
require("lua_line_config")
require("auto_session_config")
require("treesitter")
require("lsp_config")
require("copilot_config")
require("cmp_config")
require("telescope_config")
require("toggleterm_config")

print("✅ Configuration loaded!")

