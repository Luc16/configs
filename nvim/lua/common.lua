
vim.wo.number = true
vim.wo.relativenumber = true
vim.g.mouse = 'a'
vim.g.mapleader = ' '
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions,globals"
vim.opt.cmdheight = 2
vim.g.qs_highlight_on_keys = {'f', 'F', 't', 'T'}

vim.cmd("highlight QuickScopePrimary guifg='#FFD700' gui=underline ctermfg=220 cterm=underline")
vim.cmd("highlight QuickScopeSecondary guifg='#FF00FF' gui=underline ctermfg=201 cterm=underline")

vim.opt.encoding="utf-8"
vim.opt.swapfile = false
vim.opt.shell = "/usr/bin/fish"
vim.opt.foldmethod = "indent"
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
