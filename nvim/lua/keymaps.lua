--k~/.config/nvim/lua/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true, desc = "Navigate window splits" }

-- Window Navigation
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)
map('n', '<leader>w', ':bd<CR>', opts) -- May not work

-- Open a new terminal in a vertical split
map('n', '<leader>vt', ':hor term<CR>', { desc = "Open vertical terminal" })
-- Open a new terminal in a horizontal split
map('n', '<leader>ht', ':vert term<CR>', { desc = "Open horizontal terminal" })

map('n', '<C-Space>', '<Cmd>ToggleTerm<CR>', { desc = "Toggle floating terminal" })
map('n', '<leader>mp', '<Cmd>MarkdownPreviewToggle<CR>', { desc = "Toggle Markdown Preview" })
map('n', '<leader>fs', ':Telescope session-lens<CR>', { desc = "Find Session" })
-- This is the magic keymap to easily exit Terminal mode
map('t', '<C-Space>', '<C-\\><C-n><Cmd>ToggleTerm<CR>', { desc = "Exit terminal & toggle (direct)" })


-- Copilot keymaps
-- vim.api.nvim_set_keymap("i", "<leader>l", 'copilot#Accept("<CR>")', { silent = true, expr = true })

-- Enable Copilot
map('n', '<leader>ce', '<Cmd>Copilot enable<CR>', { desc = "Enable Copilot" })
-- Disable Copilot
map('n', '<leader>cd', '<Cmd>Copilot disable<CR>', { desc = "Disable Copilot" })
-- Toggle Copilot Panel
map('n', '<leader>cp', '<Cmd>Copilot panel<CR>', { desc = "Toggle Copilot Panel" })

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

map('n', '<leader>n', ':NvimTreeFindFileToggle<CR>')
map('n', '<C-M>', safe_bufferline_next, { desc = "Next Buffer (Bufferline)" })
map('n', '<C-N>', safe_bufferline_prev, { desc = "Previous Buffer (Bufferline)" })


