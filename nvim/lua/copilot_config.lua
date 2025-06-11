require("copilot").setup({
	suggestion = {
		enabled = true, -- Enable Copilot's inline virtual text suggestions
		auto_trigger = true, -- Suggestions appear as you type
		-- Optional: If you want to accept with a different key than <Tab>
		-- keymap = {
			--   accept = "<C-e>", -- Example: Use Ctrl+E to accept
			--   -- next = "<C-]>", -- Next suggestion
			--   -- prev = "<C-[>", -- Previous suggestion
			-- },
		},
  panel = {
    enabled = false, -- Disable Copilot's built-in panel (for chat etc.)
  },
})
