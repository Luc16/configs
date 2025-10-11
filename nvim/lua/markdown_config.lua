vim.g.mkdp_auto_close = 0

require("image").setup({
	backend = "kitty", -- or "ueberzug" or "sixel"
	processor = "magick_cli", -- or "magick_rock"
	integrations = {
		markdown = {
			enabled = false,
			clear_in_insert_mode = false,
			download_remote_images = true,
			only_render_image_at_cursor = false,
			only_render_image_at_cursor_mode = "popup", -- or "inline"
			floating_windows = true, -- if true, images will be rendered in floating markdown windows
			filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
		},
		neorg = {
			enabled = true,
			filetypes = { "norg" },
		},
		typst = {
			enabled = true,
			filetypes = { "typst" },
		},
		html = {
			enabled = false,
		},
		css = {
			enabled = false,
		},
	},
	max_width = nil,
	max_height = nil,
	max_width_window_percentage = nil,
	max_height_window_percentage = 50,
	scale_factor = 1.0,
	window_overlap_clear_enabled = false, -- toggles images when windows are overlapped
	window_overlap_clear_ft_ignore = { "cmp_menu", "cmp_docs", "snacks_notif", "scrollview", "scrollview_sign" },
	editor_only_render_when_focused = false, -- auto show/hide images when the editor gains/looses focus
	tmux_show_only_in_active_window = false, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
	hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp", "*.avif" }, -- render image files as images when opened
})

require('render-markdown').setup({

	indent = {
		-- Mimic org-indent-mode behavior by indenting everything under a heading based on the
		-- level of the heading. Indenting starts from level 2 headings onward by default.

		-- Turn on / off org-indent-mode.
		enabled = true,
		-- Additional modes to render indents.
		render_modes = false,
		-- Amount of additional padding added for each heading level.
		per_level = 2,
		-- Heading levels <= this value will not be indented.
		-- Use 0 to begin indenting from the very first level.
		skip_level = 1,
		-- Do not indent heading titles, only the body.
		skip_heading = false,
		-- Prefix added when indenting, one per level.
		icon = '▎',
		-- Priority to assign to extmarks.
		priority = 0,
		-- Applied to icon.
		highlight = 'RenderMarkdownIndent',
	},
	latex = {
		-- Turn on / off latex rendering.
		enabled = false,
		-- Additional modes to render latex.
		render_modes = false,
		-- Executable used to convert latex formula to rendered unicode.
		-- If a list is provided the first command available on the system is used.
		converter = { 'utftex', 'latex2text' },
		-- Highlight for latex blocks.
		highlight = 'RenderMarkdownMath',
		-- Determines where latex formula is rendered relative to block.
		-- | above  | above latex block                               |
		-- | below  | below latex block                               |
		-- | center | centered with latex block (must be single line) |
		position = 'center',
		-- Number of empty lines above latex blocks.
		top_pad = 0,
		-- Number of empty lines below latex blocks.
		bottom_pad = 0,
	},
	-- Whether to use the built-in file watcher to automatically refresh
	-- the preview when the file changes.
	auto_refresh = true,
	-- The command to use to open the preview in a browser.
	-- If nil, the default system command will be used.
	-- See `:h jobstart` for more details.
	browser_command = nil,
	-- The file types that will have the `:RenderMarkdown` command available.
	filetypes = { 'markdown' },
	-- The theme to use for rendering. This can be a string or a function
	-- that takes the current colorscheme as an argument and returns a string.
	-- If nil, the default theme will be used.
	theme = 'light',
	-- The port to use for the preview server. If nil, a random port will be used.
	port = nil,
	-- Whether to open the preview in a vertical split. If false, a horizontal
	-- split will be used.
	vertical_split = false,
	-- Whether to wrap lines in the preview. This is useful for smaller windows.
	wrap = true,
	-- Whether to show the preview in a floating window instead of a split.
	float = true,
	-- Configuration for the floating window. Only used if `float` is true.
	float_opts = {
		border = 'rounded',
		width = 100,
		height = 30,
		winblend = 0,
	},
})
