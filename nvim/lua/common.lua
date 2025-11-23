vim.wo.number = true
vim.wo.relativenumber = true
vim.g.mouse = 'a'
vim.g.mapleader = ' '
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"
vim.opt.cmdheight = 2
vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}

-- Activate spell checking for markdown and latex files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "tex" },
  callback = function()
    vim.opt_local.spell = true           -- enable spell checking
    vim.opt_local.spelllang = { "en_us", "pt_br" } -- set language(s), e.g. {"en_us", "pt_br"}
  end,
})

vim.cmd("highlight QuickScopePrimary guifg='#FFD700' gui=underline ctermfg=220 cterm=underline")
vim.cmd("highlight QuickScopeSecondary guifg='#FF00FF' gui=underline ctermfg=201 cterm=underline")

vim.opt.conceallevel = 0
vim.opt.encoding="utf-8"
vim.opt.swapfile = false
vim.opt.shell = "/usr/bin/fish"
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 99

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.scrolloff = 7
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

vim.opt.fileformat = "unix"
vim.opt.updatetime = 250
-- enable copy to clipboard
vim.opt.clipboard = "unnamedplus"

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" },
  callback = function()
    local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
    vim.cmd("silent ! xdg-open " .. filename) -- For Linux
  end,
})

vim.api.nvim_create_autocmd("BufReadCmd", {
  pattern = { "*.pdf" },
  callback = function()
    local filename = vim.fn.shellescape(vim.api.nvim_buf_get_name(0))
    vim.cmd("silent ! xdg-open " .. filename) -- For Linux
  end,
})

require("auto-save").setup({
  enabled = true,
  execution_message = {
    message = "✓",
    dim = 0.5,
    cleaning_interval = 750,
  },
  -- RECOMMENDED: Triggers on logical "pause" points in your workflow.
  -- This covers closing buffers and implicitly saves after an undo.
  trigger_events = { "InsertLeave", "BufLeave", "BufWinLeave", "FocusLost" },
  condition = function(buf)
    -- This check is crucial to prevent errors when closing buffers.
    if not vim.api.nvim_buf_is_valid(buf) then
      return false
    end

    local f_type = vim.bo[buf].filetype
    if f_type == 'gitcommit' or f_type == 'gitrebase' or vim.bo[buf].modifiable == false then
      return false
    end
    return true
  end,
})

-- This is your original, reliable function to define WHAT gets folded.
function _G.MarkdownFoldExpr()
  local line = vim.fn.getline(vim.v.lnum)
  local level = line:match('^(#+)')
  if level then
    return '>' .. #level
  else
    return '='
  end
end

-- This new function returns a TABLE of strings to create multi-line fold text.
function _G.SpacedMultiLineFoldText()
  local line_count = vim.v.foldend - vim.v.foldstart + 1
  local header_text = vim.fn.getline(vim.v.foldstart):gsub('#+ ', '')

  -- Create the main line for the fold text.
  local fold_line = string.format('▸ %s (%d lines)', header_text, line_count)

  -- THE KEY: Return a table. Each string becomes a new line.
  -- The empty strings create the blank lines above and below.
  return fold_line
end

-- Autocommand to apply these settings to markdown files
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function()
    vim.opt_local.foldmethod = 'expr'
    vim.opt_local.foldexpr = 'v:lua.MarkdownFoldExpr()'
    vim.opt_local.foldtext = 'v:lua.SpacedMultiLineFoldText()' -- Use our multi-line function
    vim.opt_local.foldlevelstart = 99
  end,
})
