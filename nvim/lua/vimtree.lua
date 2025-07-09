-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- optionally enable 24-bit colour
vim.opt.termguicolors = true


require("nvim-tree").setup({
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		float = {
			enable = true,
			open_win_config = function()
				local screen_w = vim.opt.columns:get()
				local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
				local window_w = screen_w * 0.5 -- Example: 50% of screen width
				local window_h = screen_h * 0.8 -- Example: 80% of screen height
				local window_w_int = math.floor(window_w)
				local window_h_int = math.floor(window_h)
				local center_x = (screen_w - window_w) / 2
				local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

				return {
					title = "Files", -- Optional title for the floating window
					title_pos = "center",
					border = "rounded", -- Border style ('rounded', 'single', 'double', 'none')
					relative = "editor", -- Relative to 'editor' (whole Neovim window)
					row = center_y,
					col = center_x,
					width = window_w_int,
					height = window_h_int,
				}
			end,
		}
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
	actions = {
		open_file = {
			quit_on_open = true,
		}
	},
	git = {
		enable = true,
		ignore = false,
		timeout = 500,
	},
})

