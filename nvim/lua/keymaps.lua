--k~/.config/nvim/lua/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true, desc = "Navigate window splits" }

-- Window Navigation
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)
map('n', '<leader>q', ':bd<CR>', opts)

-- Open a new terminal in a vertical split
map('n', '<leader>tv', ':hor term<CR>', { desc = "Open vertical terminal" })
-- Open a new terminal in a horizontal split
map('n', '<leader>th', ':vert term<CR>', { desc = "Open horizontal terminal" })
map('n', '<leader>tt', ':term<CR>', { desc = "Open Terminal Buffer" })

map('n', '<C-Space>', '<Cmd>ToggleTerm<CR>', { desc = "Toggle floating terminal" })
map('n', '<leader>mp', '<Cmd>MarkdownPreviewToggle<CR>', { desc = "Toggle Markdown Preview" })
map('n', '<leader>fs', ':Telescope session-lens<CR>', { desc = "Find Session" })
-- This is the magic keymap to easily exit Terminal mode
map('t', '<C-Space>', '<C-\\><C-n><Cmd>ToggleTerm<CR>', { desc = "Exit terminal & toggle (direct)" })
map('t', '<C-n>', '<C-\\><C-n>', { desc = "Exit terminal mode" })

map('n', '<leader>ss', '<Cmd>SessionSave<CR>', { desc = "Save Session" })
-- Remap f, F, t, T repeat keys
map('n', ',', ';', { desc = "Repeat find forward" })
map('n', '<leader>,', ',', { desc = "Repeat find backward" })
map('n', '<leader>y', ':%y+<CR>', { noremap = true, silent = true, desc = "Yank (copy) whole file" })

map('n', '<leader>v', 'ggVG', { noremap = true, silent = true, desc = "Select whole file" })

map('n', '<CR>', 'za', { noremap = true, silent = true, desc = "Toggle fold" })

-- Copilot keymaps
-- vim.api.nvim_set_keymap("i", "<leader>l", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Enable Copilot
map('n', '<leader>ce', '<Cmd>Copilot enable<CR><Cmd>Copilot status<CR>', { desc = "Enable Copilot" })
-- Disable Copilot and show satus
map('n', '<leader>cd', '<Cmd>Copilot disable<CR><Cmd>Copilot status<CR>', { desc = "Disable Copilot" })
-- Toggle Copilot Panel
map('n', '<leader>cp', '<Cmd>Copilot panel<CR>', { desc = "Toggle Copilot Panel" })
-- Show Copilot Status
map('n', '<leader>cs', '<Cmd>Copilot status<CR>', { desc = "Show Copilot Status" })

local function safe_bufferline_next()
  if pcall(require, 'bufferline') then
    vim.cmd('BufferLineCycleNext')
  else
    vim.cmd('bnext') -- Fallback to native Neovim command
  end
end

local function safe_bufferline_prev()
  if pcall(require, 'bufferline') then
    vim.cmd('BufferLineCyclePrev')
  else
    vim.cmd('bprevious') -- Fallback to native Neovim command
  end
end

map('n', '<leader><Tab>', ':NvimTreeFindFileToggle<CR>')
map('n', '<C-M>', safe_bufferline_next, { desc = "Next Buffer (Bufferline)" })
map('n', '<C-N>', safe_bufferline_prev, { desc = "Previous Buffer (Bufferline)" })

local function move_bufferline_next()
  if pcall(require, 'bufferline') then
    vim.cmd('BufferLineMoveNext')
  end
end

local function move_bufferline_prev()
  if pcall(require, 'bufferline') then
    vim.cmd('BufferLineMovePrev')
  end
end

map('n', '<C-.>', move_bufferline_next, { noremap = true, silent = true, desc = "Move Buffer Right (Bufferline)" })
map('n', '<C-,>', move_bufferline_prev, { noremap = true, silent = true, desc = "Move Buffer Left (Bufferline)" })
