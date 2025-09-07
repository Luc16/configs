require'nvim-treesitter.configs'.setup {
	ensure_installed = {
		"c",
		"cpp",        -- For C++
		"python",     -- For Python
		"lua",        -- For your Neovim config
		"vim",
		"vimdoc",
		"javascript",
		"typescript",
		"json",
		"yaml",
		"html",
		"css",
		"bash",
		"markdown",
		"markdown_inline",
		"latex",
	},
	auto_install = true,
    sync_install = false,
	highlight = { enable = true },
	incremental_selection = { enable = true },
	textobjects = { enable = true },
}
