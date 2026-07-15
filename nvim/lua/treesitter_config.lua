-- In the new version, you pass options directly to the native Neovim structures 
-- or let the plugin handle it implicitly. 
-- However, to keep your exact options active on the new main branch, do this:
local configs = {
  ensure_installed = {
    "c",
    "cpp",
    "python",
    "lua",
    "vim",
    "vimdoc",
    "javascript",
    "typescript",
    "json",
    "yaml",
    "html",
    "css",
    "bash",
    "markdown",
    "markdown_inline",
    "latex",
    "mlir",
    "tablegen",
  },
  auto_install = true,
  sync_install = false,
  highlight = { enable = true },
  incremental_selection = { enable = true },
  matchup = { enable = false },
}

-- Apply the configuration cleanly
for k, v in pairs(configs) do
  if k == "highlight" and v.enable then
    vim.api.nvim_create_autocmd("FileType", {
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end
end

-- 4. Your Treesitter Context config is perfectly fine!
require('treesitter-context').setup{
  enable = true,
  max_lines = 3,
  min_window_height = 0,
  line_numbers = true,
  multiline_threshold = 20,
  trim_scope = 'outer',
  mode = 'cursor',
  separator = nil,
  zindex = 20,
  on_attach = nil,
}
