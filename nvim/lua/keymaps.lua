--k~/.config/nvim/lua/keymaps.lua

local map = vim.keymap.set
local opts = { noremap = true, silent = true, desc = "Navigate window splits" }

-- Window Navigation
map('n', '<C-h>', '<C-w>h', opts)
map('n', '<C-j>', '<C-w>j', opts)
map('n', '<C-k>', '<C-w>k', opts)
map('n', '<C-l>', '<C-w>l', opts)
map('n', '<leader>q', ':bd<CR>', opts)

map("v", "<leader>p", '"_dP', { noremap = true, silent = true, desc = "Paste without overwriting register" })

-- Open a new terminal in a vertical split
map('n', '<leader>tv', ':hor term<CR>', { desc = "Open vertical terminal" })
-- Open a new terminal in a horizontal split
map('n', '<leader>th', ':vert term<CR>', { desc = "Open horizontal terminal" })
map('n', '<leader>tt', ':term<CR>', { desc = "Open Terminal Buffer" })

map('n', '<C-Space>', '<Cmd>ToggleTerm<CR>', { desc = "Toggle floating terminal" })
map('n', '<leader>mp', '<Cmd>MarkdownPreviewToggle<CR>', { desc = "Toggle Markdown Preview" })

local function show_registers()
    local lines = vim.split(vim.fn.execute("registers"), "\n", { trimempty = true })

    local max_width = 0
    for _, line in ipairs(lines) do
        max_width = math.max(max_width, vim.fn.strdisplaywidth(line))
    end

    local width = math.min(math.max(max_width + 4, 30), vim.o.columns - 4)
    local height = math.min(#lines, vim.o.lines - 4)

    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.bo[buf].modifiable = false
    vim.bo[buf].bufhidden = "wipe"

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
        style = "minimal",
        border = "rounded",
        title = " Registers ",
        title_pos = "center",
    })

    for _, key in ipairs({ "q", "<Esc>" }) do
        vim.keymap.set("n", key, function()
            if vim.api.nvim_win_is_valid(win) then
                vim.api.nvim_win_close(win, true)
            end
        end, { buffer = buf, silent = true })
    end
end

map('n', '<leader>r', show_registers, { desc = "Show registers" })

-- map('n', '<leader>r', '<Cmd>registers<CR>', { desc = "Show registers" })

map('n', '<leader>fs', ':Telescope session-lens<CR>', { desc = "Find Session" })
-- This is the magic keymap to easily exit Terminal mode
map('t', '<C-Space>', '<C-\\><C-n><Cmd>ToggleTerm<CR>', { desc = "Exit terminal & toggle (direct)" })
map('t', '<C-n>', '<C-\\><C-n>', { desc = "Exit terminal mode" })

map('n', '<leader>ss', '<Cmd>SessionSave<CR>', { desc = "Save Session" })
-- Remap f, F, t, T repeat keys
-- map('n', ',', ';', { desc = "Repeat find forward" })
-- map('n', '<leader>,', ',', { desc = "Repeat find backward" })
map('n', '<leader>y', ':%y+<CR>', { noremap = true, silent = true, desc = "Yank (copy) whole file" })
map({'n', 'v'}, '<leader>d', '"zd', { desc = "Delete into register z" })
-- Yank into register a
map({'n', 'v'}, '<leader>ay', '"ay', { desc = "Yank into register a" })
map('n', '<leader>ay', '"ay', { desc = "Yank into register a" })
-- Paste from register a
map('n', '<leader>ap', '"ap', { desc = "Paste from register a" })


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

-- Diagnostic navigation
map('n', ']j', function()
  vim.diagnostic.jump({
    count = 1,
    severity = vim.diagnostic.severity.ERROR,
  })
end, {
  noremap = true,
  silent = true,
  desc = "Go to next error",
})

map('n', ']k', function()
  vim.diagnostic.jump({
    count = -1,
    severity = vim.diagnostic.severity.ERROR,
  })
end, {
  noremap = true,
  silent = true,
  desc = "Go to previous error",
})


-- Slidev Presentation Keymap
-- map('n', '<leader>ms', function()
--     local file = vim.fn.expand("%")
--     vim.notify("Launching Slidev in Firefox...", vim.log.levels.INFO)
--     -- This sends the command directly to your ToggleTerm in the background
--     vim.cmd("TermExec cmd='slidev " .. file .. " --open'")
-- end, { desc = "Start Slidev Presentation" })
--
-- Starts the Slidev server, opens Firefox, and enables live cursor sync
map('n', '<leader>mm', '<Cmd>SlidevPreviewStart<CR>', { desc = "Start Slidev Sync" })

-- Stops the server and disconnects sync
map('n', '<leader>ms', '<Cmd>SlidevPreviewStop<CR>', { desc = "Stop Slidev Sync" })

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
