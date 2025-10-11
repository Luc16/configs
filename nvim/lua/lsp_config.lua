require("mason").setup()
require("mason-lspconfig").setup({
  -- A list of servers to automatically install if they're not already installed.
  -- We've chosen the best server for each of your languages.
  ensure_installed = {
    "clangd",     -- C/C++
    "pyright",    -- Python
    "lua_ls",     -- Lua
    "jsonls",     -- JSON
    "yamlls",     -- YAML
    "html",       -- HTML
    "cssls",      -- CSS
    "bashls",     -- Bash
    "marksman",   -- Markdown
	"texlab",     -- LaTeX
  },
})

-- 2. Define the 'on_attach' function
-- This function runs once for each language server that starts.
-- We use it to set keymaps and other buffer-local settings.
local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end
    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc, noremap = true, silent = true })
  end

  -- Core LSP features
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

  -- Refactoring and other actions
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  -- Diagnostics (errors and warnings)
  nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic')
  nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic')
  -- nmap('<leader>q', vim.diagnostic.setloclist, 'Open diagnostics list')
end

-- 3. Configure all language servers
local lspconfig = require('lspconfig')
local capabilities = require('cmp_nvim_lsp').default_capabilities() -- Capabilities for nvim-cmp

-- This loop sets up every server that mason-lspconfig has installed.
-- It attaches the keymaps and capabilities we defined above.
for _, server_name in ipairs(require("mason-lspconfig").get_installed_servers()) do
  lspconfig[server_name].setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- 4. Custom setup for the Lua language server
-- This tells lua_ls about the Neovim runtime API, so you get completion for `vim.fn` etc.
lspconfig.lua_ls.setup {
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = {'vim'} },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
    },
  },
}

local diagnostics_group = vim.api.nvim_create_augroup("ShowDiagnosticsOnHover", { clear = true })

vim.api.nvim_create_autocmd("CursorHold", {
  group = diagnostics_group,
  pattern = "*",
  callback = function()
    vim.diagnostic.open_float(nil, {
      scope = "cursor", -- Only show diagnostics for the cursor position
      focusable = false,  -- Make the window not focusable
      source = "always",  -- Show the source of the diagnostic (e.g., "pyright")
      header = "",
      prefix = " ",
    })
  end,
  desc = "Show diagnostics on hover",
})



require("lsp_signature").setup({
  bind = true, -- This is mandatory, otherwise border config won't get registered.
  floating_window = true,
  hint_enable = false,
  handler_opts = {
	border = "rounded"
  },
})


--   bind = true, -- This is the default, tells the plugin to show signature help automatically
--   doc_lines = 0, -- Number of documentation lines to show in the signature help, 0 disables it
--   floating_window = true, -- Use a floating window for the signature help
--   hint_enable = true, -- Show a virtual text hint with parameter information
--   hint_prefix = "💡 ", -- Prefix for the virtual text hint
--   handler_opts = {
--     border = "rounded" -- Style of the floating window border
--   },
--   zindex = 200, -- The z-index of the floating window
-- })
