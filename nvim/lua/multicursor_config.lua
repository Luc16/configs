-- ~/.config/nvim/lua/multicursor_config.lua

local set = vim.keymap.set

-- Set up some keymaps that are only active when multicursor is enabled.
-- You can also use the Cursor API to create your own actions.
local multicursor = require('multicursor-nvim')

multicursor.setup({})

set({"n", "x"}, "<up>", function() multicursor.lineAddCursor(-1) end)
set({"n", "x"}, "<down>", function() multicursor.lineAddCursor(1) end)
set({"n", "x"}, "<leader><up>", function() multicursor.lineSkipCursor(1) end)
set({"n", "x"}, "<leader><down>", function() multicursor.lineSkipCursor(1) end)

-- Add or skip adding a new cursor by matching word/selection
-- set({"n", "x"}, "<leader>n", function() multicursor.matchAddCursor(1) end)
set({"n", "x"}, ";", function() multicursor.matchAddCursor(1) end)
set({"n", "x"}, "<leader>s", function() multicursor.matchSkipCursor(1) end)
set({"n", "x"}, "<c-;>", function() multicursor.matchAddCursor(-1) end)
set({"n", "x"}, "<leader>S", function() multicursor.matchSkipCursor(-1) end)

-- Add and remove cursors with control + left click.
set("n", "<c-leftmouse>", multicursor.handleMouse)
set("n", "<c-leftdrag>", multicursor.handleMouseDrag)
set("n", "<c-leftrelease>", multicursor.handleMouseRelease)

-- Disable and enable cursors.
set({"n", "x"}, "<c-q>", multicursor.toggleCursor)


multicursor.addKeymapLayer(function(layerSet)
	-- Select a different cursor as the main one.
	layerSet({"n", "x"}, "<left>", multicursor.prevCursor)
	layerSet({"n", "x"}, "<right>", multicursor.nextCursor)

	-- Delete the main cursor.
	layerSet({"n", "x"}, "<leader>x", multicursor.deleteCursor)

	-- Enable and clear cursors using escape.
	layerSet("n", "<esc>", function()
		if not multicursor.cursorsEnabled() then
			multicursor.enableCursors()
		else
			multicursor.clearCursors()
		end
	end)
end)
