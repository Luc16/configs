local suppressed_dirs = {
	'~', '/', '~/Downloads', '~/Documents',
}


require('auto-session').setup({
	log_level = 'info',
	auto_save = true, -- Enables/disables auto saving session on exit
	auto_restore = true, -- Enables/disables auto restoring session on start
	auto_create = true,
	auto_session_enable_current_dir = true, -- Optional: Set to true if you want to restore if a session exists in the current directory
	auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
    auto_restore_last_session = vim.loop.cwd() == vim.loop.os_homedir(),
	auto_session_suppress_dirs = suppressed_dirs,
	auto_session_use_git_branch = true,
	args_allow_files_auto_save = false,
	pre_restore_cmds = { "BufferlineDisable" },
	post_restore_cmds = {
		"BufferlineEnable",
		function()
			-- Restore nvim-tree after a session is restored
			local nvim_tree_api = require('nvim-tree.api')
			-- nvim_tree_api.tree.open()
			nvim_tree_api.tree.change_root(vim.fn.getcwd())
			nvim_tree_api.tree.reload()
		end
	},
	session_lens = {
		load_on_setup = true,
		theme_conf = { border = true },
	},

})

vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		pcall(function()
			vim.cmd("SessionSave")
		end)
		end
	})


