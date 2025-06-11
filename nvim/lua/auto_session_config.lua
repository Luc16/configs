local suppressed_dirs = {
	'/', '~/Downloads', '~/Documents',
}

-- Define the path for the file that stores the last session path
local last_session_file = vim.fn.stdpath('data') .. "/auto-session-last-path"

require('auto-session').setup({
	log_level = 'info',
	-- Set this to false. We will manage last session restoration explicitly via our autocommands.
	auto_session_enable_last_session = false,
	-- auto_session_enable_current_dir = true, -- Optional: Set to true if you want to restore if a session exists in the current directory
	auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
	auto_session_suppress_dirs = suppressed_dirs,
	auto_session_use_git_branch = true,
	pre_restore_cmds = { "BufferlineDisable" },
	post_restore_cmds = { "BufferlineEnable" },
	session_lens = {
		load_on_setup = true,
		theme_conf = { border = true },
		previewer = true,
	},
})

-- Load last session path from file on VimEnter for persistence across restarts
-- This autocommand runs first to get the last session path for the current Neovim instance.
vim.api.nvim_create_autocmd("VimEnter", {
	pattern = "*",
	callback = function()
		-- Attempt to read the last session path from the designated file
		local f = io.open(last_session_file, "r")
		if f then
			_G.last_session_path = f:read("*l") -- Read the entire line
			f:close()
			-- Validate that the path exists and is readable, otherwise clear it
			if _G.last_session_path == "" or not vim.fn.filereadable(_G.last_session_path) then
				_G.last_session_path = nil -- Clear if the path is invalid or file doesn't exist
			end
		else
			_G.last_session_path = nil -- File doesn't exist, so no last path
		end

		local home = vim.env.HOME
		local cwd = vim.loop.cwd()

		-- Now, with _G.last_session_path potentially loaded from file,
		-- only restore if in home directory AND a last session path exists.
		if cwd == home and _G.last_session_path then
			vim.schedule(function()
				-- Save the current initial (likely empty) session state.
				-- This prevents the initial session from being lost if you want to
				-- restore to it after closing the restored one.
				vim.cmd("SessionSave")

				-- Restore the last session from the persisted path
				vim.cmd("SessionRestoreFromFile " .. vim.fn.fnameescape(_G.last_session_path))
				vim.notify("Restored session: " .. require('auto-session').CurrentSessionName, vim.log.levels.INFO)
			end)
		end
	end
})
-- Use this improved debugging approach
local function debug_log(msg)
	-- Write to a log file
	local log = io.open("/tmp/nvim_debug.log", "a")
	if log then
		log:write(os.date("%Y-%m-%d %H:%M:%S") .. " | " .. msg .. "\n")
		log:close()
	end

	-- Print to :messages (only when not in leave events)
	if vim.v.event and vim.v.event.name ~= "VimLeavePre" then
		vim.cmd("echom 'DEBUG: " .. msg:gsub("'", "''") .. "'")
	end
end

-- Fixed VimLeavePre with safe operations
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		debug_log("VimLeavePre STARTED")


		-- Safe session save
		pcall(function()
			vim.cmd("SessionSave")
			debug_log("Session saved successfully")
		end)

		local current_session_path = require('auto-session').SessionPath
		debug_log("Current session path set to: " .. current_session_path)

		if current_session_path then
			_G.last_session_path = current_session_path
			debug_log("Current session path set to: " .. current_session_path)
		else
			debug_log("No current session path found, not saving last session path")
		end

		-- Safe notification
		pcall(vim.notify, "VimLeavePre triggered", vim.log.levels.INFO)
		debug_log("VimLeavePre COMPLETED")
		end
	})

	-- Working BufWritePost example
	vim.api.nvim_create_autocmd("BufWritePost", {
		pattern = "*",
		callback = function()
			debug_log("BufWritePost triggered for: " .. vim.fn.expand("%"))
			vim.notify("File saved: " .. vim.fn.expand("%"), vim.log.levels.INFO)
		end
	})
