-- ~/.config/nvim/lua/hop_config.lua

local hop = require('hop')
local directions = require('hop.hint').HintDirection
local map = vim.keymap.set

-- Configure hop
hop.setup {
  keys = 'etovxqpdygfblzhckisuran'
}

-- Keymaps for word, line, and character jumps
-- map('n', 's', function()
--   hop.hint_words()
-- end, { desc = "Hop to word" })
--
-- map('n', 'S', function()
--   hop.hint_lines()
-- end, { desc = "Hop to line" })

-- You can still use the old f/t mappings, but these are the Hop equivalents
-- map('n', 'f', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
-- end, { desc = "Hop to char after cursor" })
--
-- map('n', 'F', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
-- end, { desc = "Hop to char before cursor" })
--
-- map('n', 't', function()
--   hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
-- end, { desc = "Hop to char before cursor" })
--
-- map('n', 'T', function()
--   hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
-- end, { desc = "Hop to char after cursor" })


-- normal mode (easymotion-like)
-- map("n", "<Leader>b", "<cmd>HopWordBC<CR>", {noremap=true})
map({'n', 'v'}, "<Leader>w", "<cmd>HopWord<CR>", {noremap=true, desc = "Hop to word"})
map({'n', 'v'}, "<Leader>e", function()
  local hop = require('hop')
  hop.hint_words({
    current_line_only = false,
    hint_position = require('hop.hint').HintPosition.END,
  })
end, { noremap = true, desc = "Hop to end of word" })
map({'n', 'v'}, "<Leader>j", "<cmd>HopLine<CR>", {noremap=true, desc = "Hop to line"})
map({'n', 'v'}, "<Leader>k", "<cmd>HopLine<CR>", {noremap=true, desc = "Hop to line"})


-- -- normal mode (sneak-like)
-- map("n", "s", "<cmd>HopChar2AC<CR>", {noremap=false})
-- map("n", "S", "<cmd>HopChar2BC<CR>", {noremap=false})
--
-- -- visual mode (sneak-like)
-- map("v", "s", "<cmd>HopChar2AC<CR>", {noremap=false})
-- map("v", "S", "<cmd>HopChar2BC<CR>", {noremap=false})


