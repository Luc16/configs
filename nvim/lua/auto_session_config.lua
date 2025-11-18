-- lua/auto_session_config.lua

local suppressed_dirs = {
	'~/', '/', '~/Downloads/', '~/Documents/',
}
local should_restore_last_session = (vim.v.argv == nil or #vim.v.argv == 2) and (not _G.OPEN_DASHBOARD)
-- print(vim.v.argv[1], vim.v.argv[2], vim.v.argv[3], #vim.v.argv, should_restore_last_session, _G.OPEN_DASHBOARD)

require('auto-session').setup({
	log_level = 'info',
	auto_save = true, -- Enables/disables auto saving session on exit
	auto_restore = true, -- Enables/disables auto restoring session on start
	auto_create = true,
	auto_session_enable_current_dir = true, -- Optional: Set to true if you want to restore if a session exists in the current directory
	auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
    auto_restore_last_session = should_restore_last_session,
	auto_session_suppress_dirs = suppressed_dirs,
	auto_session_use_git_branch = true,
	args_allow_files_auto_save = false,
	args_allow_single_directory = true,
	pre_restore_cmds = {
        "BufferlineDisable",
        -- ADDED: Disable Treesitter highlighting before restore
        function() vim.cmd("TSDisable highlight") end
    },
	post_restore_cmds = {
		"BufferlineEnable",
        -- ADDED: Re-enable Treesitter highlighting after restore
        function()
            -- We use vim.schedule to ensure this runs after everything is fully loaded
            vim.schedule(function()
                vim.cmd("TSEnable highlight")
            end)
        end,
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
