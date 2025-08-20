local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

bufferline.setup({
  options = {
    -- Appearance and Layout
    offsets = {{filetype = "NvimTree", text = "File Explorer", text_align = "left", separator = true}}, -- For sidebar_filetypes like NvimTree, mimics Barbar's visual offset
    separator_style = "slant", -- 'slant' or 'padded_slant' are good alternatives to Barbar's '▎'
    -- 'thin', 'bold', 'round', 'slant', 'padded_slant'

    -- Icons (requires nvim-web-devicons, which you already have)
    show_buffer_icons = true,
    show_close_icon = true, -- Displays the close button for each buffer
    buffer_close_icon = "\u{f461}", -- Mimics Barbar's button icon
    modified_icon = "●", -- Mimics Barbar's modified button icon

    -- Buffer numbering (Barbar had buffer_index = false, buffer_number = false)
    numbers = "none", -- 'none' | 'ordinal' | 'buffer_id' | 'both'

    -- Naming and Lengths
    max_name_length = 30, -- Similar to Barbar's maximum_length
    min_name_length = 0,  -- Similar to Barbar's minimum_length
    padding = 1,          -- Similar to Barbar's min/max padding

    -- Behavior
    clickable = true, -- Buffers are clickable by default
    insert_buffer_at_end = true, -- Similar to Barbar's insert_at_end
    buffer_close_to_right = false, -- Similar to Barbar's focus_on_close = 'left' (closes to nearest/left)

    -- Filtering (similar to Barbar's exclude_ft and exclude_name)
    exclude_filetype_from_buffer = {"javascript", "Outline"}, -- Exclude by filetype
    exclude_filename_from_buffer = {"package.json"}, -- Exclude by filename

    -- Diagnostics (mimics Barbar's diagnostics setup)
    diagnostics = "nvim_lsp", -- Show LSP diagnostics
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      -- Custom icons based on level, similar to your Barbar config
      local icon_map = {
        error = "\u{fb00}", -- Barbar's error icon
        warn = "\u{f071}",  -- Common warning icon
        info = "\u{f05a}",  -- Common info icon
        hint = "\u{f06a}",  -- Common hint icon
      }
      -- Show icon only for errors and hints (as per your Barbar config)
      if level == "error" or level == "hint" then
        return " " .. (icon_map[level] or "") .. (count > 0 and " " .. count or "") .. " "
      end
      return "" -- Don't show anything for warn/info if not enabled
    end,

    -- Git signs (mimics Barbar's gitsigns setup)
    gitsigns = {
      added = { icon = '+' },
      changed = { icon = '~' },
      deleted = { icon = '-' },
    },

    -- Other useful bufferline options
    sort_by = "id", -- Keep buffers sorted by their buffer ID (default)
    right_mouse_command = "BufferLineCloseRight", -- Command for right-clicking on a buffer
    middle_mouse_command = "BufferLineClose",     -- Command for middle-clicking on a buffer
    focus_on_command = true, -- When using commands like 'BufferLineClose', focus on the next buffer.
  },
highlights = {
  },
})

-- Define custom commands for auto-session interaction
-- These will be called by auto-session to hide/show the bufferline.
vim.api.nvim_create_user_command('BufferlineDisable', function()
  -- Temporarily hide the tabline where bufferline renders
  -- This will hide bufferline and any other tabline content.
  vim.opt.showtabline = 0
end, {})

vim.api.nvim_create_user_command('BufferlineEnable', function()
  vim.schedule(function()
    -- Restore the tabline visibility
    -- 2: show tabline only if there are at least two windows/tabs (recommended)
    -- 1: always show tabline
    vim.opt.showtabline = 2
    -- You might want to explicitly redraw bufferline if it doesn't refresh automatically
    pcall(function() require('bufferline').set_buffer_id_offset(0) end) -- A common trick to force redraw
  end)
end, {})

-- Keymaps (already handled in your keymaps.lua and fall back to native if bufferline is not loaded)
-- If you relied on Barbar's semantic buffer numbers (e.g., <leader>1 for buffer 1),
-- bufferline.nvim typically provides its own direct jump keymaps like <leader>1, <leader>2 etc.
-- You can set them up in your keymaps.lua if you prefer:
-- vim.keymap.set('n', '<leader>1', '<Cmd>BufferLineGoToBuffer 1<CR>', { desc = 'Go to Buffer 1' })
-- ...and so on for other numbers.
