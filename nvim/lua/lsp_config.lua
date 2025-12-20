-- 1. Setup Mason to manage your server binaries
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "clangd",
    "pyright",
    "lua_ls",
    "jsonls",
    "yamlls",
    "html",
    "cssls",
    "bashls",
    "marksman",
    "texlab",
    "kotlin_lsp",
  },
  automatic_enable = true,
})

-- 2. Define Keymaps and Logic via LspAttach (Modern Way)
-- This applies to any LSP that starts, regardless of the server.
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    local nmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. (desc or ""), noremap = true, silent = true })
    end

    -- Navigation
    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', vim.lsp.buf.references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    
    -- Documentation and Help
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Help')

    -- Refactoring
    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    -- Diagnostics
    nmap('[d', vim.diagnostic.goto_prev, 'Go to previous diagnostic')
    nmap(']d', vim.diagnostic.goto_next, 'Go to next diagnostic')

    -- Optional: Setup signature help if the plugin is installed
    local sig_ok, lsp_signature = pcall(require, "lsp_signature")
    if sig_ok then
      lsp_signature.on_attach({
        bind = true,
        floating_window = true,
        handler_opts = { border = "rounded" },
      }, bufnr)
    end
  end,
})

-- 3. Configure Servers (Future-proof Native API)
-- Neovim 0.11+ automatically merges these with defaults from nvim-lspconfig.

-- Kotlin: Set target to Java 1.8 to match your build.gradle
-- Define the server name and launch command
vim.lsp.config('kotlin_lsp', {
  cmd = { 'kotlin-lsp', '--stdio' }, -- Ensure 'kotlin-lsp' is in your $PATH
  filetypes = { 'kotlin', 'kt', 'kts' },
  root_markers = { 'settings.gradle', 'build.gradle', 'build.gradle.kts', '.git' },
  settings = {}
})

-- Lua: Setup workspace for Neovim development
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = {'vim'} },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
    },
  },
})

vim.lsp.config('clangd', { 
	cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=never", "--completion-style=detailed", "--function-arg-placeholders", "--fallback-style=llvm", }, 
	root_markers = { "compile_commands.json", "compile_flags.txt", ".git" }, 
})

-- 4. Enable the Servers
-- This replaces the old .setup() loop. Servers only start when you open a relevant file.
vim.lsp.enable({
  "clangd",
  "pyright",
  "lua_ls",
  "jsonls",
  "yamlls",
  "html",
  "cssls",
  "bashls",
  "marksman",
  "texlab",
  "kotlin_language_server",
})

-- 5. Standard UI configurations
vim.filetype.add({
  extension = { td = "tablegen", mlir = "mlir" },
})

-- Hover diagnostics auto-command
local diagnostics_group = vim.api.nvim_create_augroup("ShowDiagnosticsOnHover", { clear = true })
vim.api.nvim_create_autocmd("CursorHold", {
  group = diagnostics_group,
  callback = function()
    vim.diagnostic.open_float(nil, { 
      scope = "cursor", 
      focusable = false, 
      source = "always",
      header = "",
      prefix = " ",
    })
  end,
})
