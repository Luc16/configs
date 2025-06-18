local gitsigns_status_ok, gitsigns = pcall(require, "gitsigns")
if not gitsigns_status_ok then
	return
end

gitsigns.setup({
	signs = {
		add = { text = '+' },
		change = { text = '~' },
		delete = { text = '' },
		topdelete = { text = '▤' },
		untracked = { text = '┆' },
	},
	signs_staged = {
		add = { text = '+' },
		change = { text = '~' },
		delete = { text = '' },
		topdelete = { text = '▤' },
		untracked = { text = '┆' },
	},
	signcolumn = true,
	numhl = false,
	linehl = false,
	word_diff = false,
	watch_gitdir = {
		interval = 1000,
		follow_files = true,
	},
	attach_to_untracked = true,
	current_line_blame = true,
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = 'eol',
		delay = 500,
		ignore_whitespace = false,
	},
	current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',

	-- Define keybindings apenas quando o plugin estiver ativo no buffer
	on_attach = function(bufnr)
		local gs = package.loaded.gitsigns
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
		end
		local function toggle()
			gs.toggle_numhl()
			gs.toggle_deleted()
			gs.toggle_linehl()
			gs.toggle_word_diff()
		end

		vim.keymap.set('n', ']h', function()
			if vim.wo.diff then return ']h' end
			vim.schedule(function() gs.next_hunk() end)
			return '<Ignore>'
		end, {expr = true, buffer = bufnr, desc = "Next Git hunk"}) -- Corrected!

		vim.keymap.set('n', '[h', function()
			if vim.wo.diff then return '[h' end
			vim.schedule(function() gs.prev_hunk() end)
			return '<Ignore>'
		end, {expr = true, buffer = bufnr, desc = "Previous Git hunk"}) -- Corrected!

		-- Normal mode mappings
		map('n', '<leader>gs', gs.stage_hunk, "Stage Git hunk")
		map('n', '<leader>gr', gs.reset_hunk, "Reset Git hunk")
		map('n', '<leader>gS', gs.stage_buffer, "Stage buffer")
		map('n', '<leader>gu', gs.undo_stage_hunk, "Undo staged hunk")
		map('n', '<leader>gR', gs.reset_buffer, "Reset buffer")
		map('n', '<leader>gb', gs.toggle_current_line_blame, "Toggle line blame")
		map('n', '<leader>gd', gs.diffthis, "Diff this")
		map('n', '<leader>gq', function() vim.cmd('Gitsigns setqflist all') end, "Populate quickfix with hunks")
		map('n', '<leader>gt', toggle)
		map('n', '<leader>gl', gs.preview_hunk, "Preview Git hunk for current line")
		-- Visual mode mappings
		map('v', '<leader>gs', function()
			gs.stage_hunk { vim.fn.line("."), vim.fn.line("v") }
		end, "Stage selected hunk")

		map('v', '<leader>gr', function()
			gs.reset_hunk { vim.fn.line("."), vim.fn.line("v") }
		end, "Reset selected hunk")
		map('v', '<leader>gp', function()
			gs.preview_hunk_inline()
		end, "Preview selected hunk inline")

		-- Text objects for Git hunks
		map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', "Inner hunk")
		map({'o', 'x'}, 'ah', ':<C-U>Gitsigns select_hunk<CR>', "Around hunk")
	end,
})
