local Path = require("plenary.path")

local hex_to_char = function(x)
  return string.char(tonumber(x, 16))
end

local unescape = function(url)
  return url:gsub("%%(%x%x)", hex_to_char)
end

local function get_recent_sessions()
	local session_dir = vim.fn.stdpath("data") .. "/sessions/"
	local session_files = vim.fn.glob(session_dir .. "*.vim", true, true)

    if vim.fn.isdirectory(session_dir) == 0 then
        return {} -- Return empty if session directory doesn't exist
    end

	local local_sessions = {}
	for _, path in ipairs(session_files) do
		local decoded_path = unescape(path)

		-- 3. Remove the ".vim" extension
		local without_extension = decoded_path:gsub("%.vim$", "")

		start_index, end_index = string.find(without_extension, "sessions/")


		local final_name = ""
		if end_index then -- Check if the substring was found
			final_name = string.sub(without_extension, end_index + 1)
		end

		-- print(final_name, " - ", without_extension)

		local time = vim.fn.getftime(path)

		table.insert(local_sessions, {name = final_name, time = time})

	end

	-- Sort sessions by modification time (most recent first)
	table.sort(local_sessions, function(a, b)
		return a.time > b.time
	end)

	local items = {}
	local limit = math.min(#local_sessions, 10) -- Show up to 10 recent sessions
	for i = 1, limit do
		local session_name = local_sessions[i].name

		table.insert(items, {
			icon = " ", -- A clock icon for recent items
			desc = session_name,
			action = function()
				vim.cmd("SessionRestore " .. session_name)
			end,
		})
	end

	return items
end

local recent_sessions = get_recent_sessions()

require("snacks").setup({
	bigfile = {enabled = true},
	dashboard = {
		enabled = _G.OPEN_DASHBOARD, -- Set to true if you want to open the dashboard on startup
		width = 60,
		row = nil, -- dashboard position. nil for center
		col = nil, -- dashboard position. nil for center
		pane_gap = 4, -- empty columns between vertical panes
		autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
		-- These settings are used by some built-in sections
		preset = {
			-- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
			---@type fun(cmd:string, opts:table)|nil
			pick = nil,
			-- Used by the `keys` section to show keymaps.
			-- Set your custom keymaps here.
			-- When using a function, the `items` argument are the default keymaps.
			---@type snacks.dashboard.Item[]
			keys = {
				{ icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
				{ icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },

				{ icon = " ", key = "t", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
				{ icon = " ", key = "c", desc = "Config", action = ":SessionRestore /home/luc/.config|master" },
				{ icon = " ", key = "r", desc = "Restore Last Session", action = recent_sessions[1].action, },
				{ icon = "", key = "s", desc = "Search All Sessions", action = ":Autosession search" },
				{ icon = " ", key = "m", desc = "Manage Sessions", action = ":Autosession delete" },
				{ icon = " ", key = "q", desc = "Quit", action = ":qa" },
			},
			-- Used by the `header` section
			header = [[
			███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
			████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
			██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
			██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
			██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
			╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
		},
		-- item field formatters
		formats = {
			icon = function(item)
				-- if item.file and (item.icon == "file" or item.icon == "directory") then
				-- 	return dashboard.icon(item.file, item.icon)
				-- end
				return { item.icon, width = 2, hl = "icon" }
			end,
			footer = { "%s", align = "center" },
			header = { "%s", align = "center" },
			file = function(item, ctx)
				local fname = vim.fn.fnamemodify(item.file, ":~")
				fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
				if #fname > ctx.width then
					local dir = vim.fn.fnamemodify(fname, ":h")
					local file = vim.fn.fnamemodify(fname, ":t")
					if dir and file then
						file = file:sub(-(ctx.width - #dir - 2))
						fname = dir .. "/…" .. file
					end
				end
				local dir, file = fname:match("^(.*)/(.+)$")
				return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
			end,
		},
		sections = {
			{ section = "header" },
			{
				pane = 2,
				section = "terminal",
				cmd = "colorscript -e square",
				height = 5,
				padding = 1,
			},
			{ section = "keys", gap = 1, padding = 1 },
			--          { pane = 2, icon = " ", title = "Recent Sessions", indent = 2, padding = 1, items = get_recent_sessions },
			-- { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
			-- { title = "Projects", items = sessions_as_projects(), pane = 2 },
			{
				pane = 2,
				icon = " ",
				title = "Git Status",
				section = "terminal",
				enabled = false,
				cmd = "git status --short --branch --renames",
				height = 5,
				padding = 1,
				ttl = 5 * 60, -- Time-to-live cache for 5 minutes
				indent = 3,
			},
		},

	},
	explorer = {enabled = true},
	indent = {
		enabled = true,
		animate = {
			enabled = false,
		}
	},
	input = {enabled = true},
	notifier = {
		timeout = 3000,
	},
	picker = {
		enabled = true,

		-- This is the new, correct configuration section
		win = {
			-- Keymaps for when you are in the INPUT prompt window
			input = {
				keys = {
					-- Normal mode mappings for the input window
						['<leader>l'] = "focus_preview",
						['<leader>h'] = "focus_list",
				}
			},
			-- Keymaps for when you are in the RESULTS list window
			list = {
				keys = {
					-- Normal mode mappings for the list window
						['<leader>l'] = "focus_preview",
				-- ['<leader>h'] = "focus_input", -- 'focus_input' is correct for returning from the preview
				}
			},
			preview = {
				keys = {
					-- Normal mode mappings for the preview window
					['<leader>l'] = "focus_list",
					['<leader>h'] = "focus_input", -- 'focus_input' is correct for returning from the preview
				}
			},
		}
	},
	quickfile = {enabled = true},
	scope = {enabled = true},
	scroll = {enabled = false},
	statuscolumn = {enabled = true},
	words = {enabled = true},
	styles = {
		notification = {
			-- wo = { wrap = true } -- Wrap notifications
		},
	},
})

-- 2. Run the initialization logic AFTER setting up the plugin
vim.api.nvim_create_autocmd("User", {
  pattern = "VeryLazy",
  callback = function()
    -- The global 'Snacks' is now available for use here
    _G.dd = function(...)
      require("snacks").debug.inspect(...)
    end
    _G.bt = function()
      require("snacks").debug.backtrace()
    end
    vim.print = _G.dd -- Override print to use snacks for `:=` command

    -- Create toggle mappings
    require("snacks").toggle.option("spell", { name = "Spelling" }):map("<leader>us")
    require("snacks").toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
    require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
    require("snacks").toggle.diagnostics():map("<leader>ud")
    require("snacks").toggle.line_number():map("<leader>ul")
    require("snacks").toggle.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
    require("snacks").toggle.treesitter():map("<leader>uT")
    require("snacks").toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
    require("snacks").toggle.inlay_hints():map("<leader>uh")
    require("snacks").toggle.indent():map("<leader>ug")
    require("snacks").toggle.dim():map("<leader>uD")
  end,
})

-- Helper function to make keymapping simpler
local map = vim.keymap.set

-- Use the global 'Snacks' variable, which is available after setup.
-- The format is: map(mode, lhs, rhs, { desc = "description" })

-- Top Pickers & Explorer
map("n", "<leader><space>", function() Snacks.picker.smart() end, { desc = "Snacks: Smart Find Files" })
map("n", "<leader>,", function() Snacks.picker.buffers() end, { desc = "Snacks: Buffers" })
map("n", "<leader>/", function() Snacks.picker.grep() end, { desc = "Snacks: Grep" })
map("n", "<leader>:", function() Snacks.picker.command_history() end, { desc = "Snacks: Command History" })
-- map("n", "<leader>n", function() Snacks.picker.notifications() end, { desc = "Snacks: Notification History" })
-- map("n", "<leader>e", function() Snacks.explorer() end, { desc = "Snacks: File Explorer" })

-- Find
map("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Snacks: Find Buffers" })
map("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Snacks: Find Config File" })
map("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Snacks: Find Files" })
map("n", "<leader>fs", function() vim.cmd(":Autosession search") end, { desc = "Snacks: Find Sessions" })
-- map("n", "<leader>fg", function() Snacks.picker.git_files() end, { desc = "Snacks: Find Git Files" })
map("n", "<leader>fg", function() Snacks.picker.grep() end, { desc = "Snacks: Grep" })
map("n", "<leader>fp", function() Snacks.picker.projects() end, { desc = "Snacks: Projects" })
map("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Snacks: Recent Files" })

-- Git
map("n", "<leader>gb", function() Snacks.picker.git_branches() end, { desc = "Snacks: Git Branches" })
map("n", "<leader>gl", function() Snacks.picker.git_log() end, { desc = "Snacks: Git Log" })
map("n", "<leader>gL", function() Snacks.picker.git_log_line() end, { desc = "Snacks: Git Log for Line" })
map("n", "<leader>gs", function() Snacks.picker.git_status() end, { desc = "Snacks: Git Status" })
map("n", "<leader>gS", function() Snacks.picker.git_stash() end, { desc = "Snacks: Git Stash" })
map("n", "<leader>gd", function() Snacks.picker.git_diff() end, { desc = "Snacks: Git Diff (Hunks)" })
map("n", "<leader>gf", function() Snacks.picker.git_log_file() end, { desc = "Snacks: Git Log for File" })

-- Grep
map("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "Snacks: Search Buffer Lines" })
map("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "Snacks: Grep Open Buffers" })
map("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "Snacks: Grep" })
map({ "n", "x" }, "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "Snacks: Grep Word/Selection" })

-- Search Pickers
map("n", '<leader>s"', function() Snacks.picker.registers() end, { desc = "Snacks: Search Registers" })
map("n", '<leader>s/', function() Snacks.picker.search_history() end, { desc = "Snacks: Search History" })
map("n", "<leader>sa", function() Snacks.picker.autocmds() end, { desc = "Snacks: Search Autocmds" })
map("n", "<leader>sc", function() Snacks.picker.command_history() end, { desc = "Snacks: Search Command History" })
map("n", "<leader>sC", function() Snacks.picker.commands() end, { desc = "Snacks: Search Commands" })
map("n", "<leader>sd", function() Snacks.picker.diagnostics() end, { desc = "Snacks: Search Diagnostics" })
map("n", "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, { desc = "Snacks: Search Buffer Diagnostics" })
map("n", "<leader>sh", function() Snacks.picker.help() end, { desc = "Snacks: Search Help Pages" })
map("n", "<leader>sH", function() Snacks.picker.highlights() end, { desc = "Snacks: Search Highlights" })
map("n", "<leader>si", function() Snacks.picker.icons() end, { desc = "Snacks: Search Icons" })
map("n", "<leader>sj", function() Snacks.picker.jumps() end, { desc = "Snacks: Search Jumps" })
map("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "Snacks: Search Keymaps" })
map("n", "<leader>sl", function() Snacks.picker.loclist() end, { desc = "Snacks: Search Location List" })
map("n", "<leader>sm", function() Snacks.picker.marks() end, { desc = "Snacks: Search Marks" })
map("n", "<leader>sM", function() Snacks.picker.man() end, { desc = "Snacks: Search Man Pages" })
map("n", "<leader>sp", function() Snacks.picker.lazy() end, { desc = "Snacks: Search Plugin Spec" })
map("n", "<leader>sq", function() Snacks.picker.qflist() end, { desc = "Snacks: Search Quickfix List" })
map("n", "<leader>sR", function() Snacks.picker.resume() end, { desc = "Snacks: Resume Last Picker" })
map("n", "<leader>su", function() Snacks.picker.undo() end, { desc = "Snacks: Search Undo History" })
map("n", "<leader>uC", function() Snacks.picker.colorschemes() end, { desc = "Snacks: Colorschemes" })

-- LSP
map("n", "gd", function() Snacks.picker.lsp_definitions() end, { desc = "Snacks: Goto Definition" })
map("n", "gD", function() Snacks.picker.lsp_declarations() end, { desc = "Snacks: Goto Declaration" })
map("n", "gr", function() Snacks.picker.lsp_references() end, { desc = "Snacks: References", nowait = true })
map("n", "gI", function() Snacks.picker.lsp_implementations() end, { desc = "Snacks: Goto Implementation" })
map("n", "gy", function() Snacks.picker.lsp_type_definitions() end, { desc = "Snacks: Goto Type Definition" })
-- map("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "Snacks: LSP Document Symbols" })
-- map("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "Snacks: LSP Workspace Symbols" })

-- Other
map("n", "<leader>z", function() Snacks.zen() end, { desc = "Snacks: Toggle Zen Mode" })
map("n", "<leader>Z", function() Snacks.zen.zoom() end, { desc = "Snacks: Toggle Zoom" })
map("n", "<leader>.", function() Snacks.scratch() end, { desc = "Snacks: Toggle Scratch Buffer" })
map("n", "<leader>S", function() Snacks.scratch.select() end, { desc = "Snacks: Select Scratch Buffer" })
map("n", "<leader>bd", function() Snacks.bufdelete() end, { desc = "Snacks: Delete Buffer" })
map("n", "<leader>cR", function() Snacks.rename.rename_file() end, { desc = "Snacks: Rename File" })
map({ "n", "v" }, "<leader>gB", function() Snacks.gitbrowse() end, { desc = "Snacks: Git Browse" })
map("n", "<leader>gg", function() Snacks.lazygit() end, { desc = "Snacks: Lazygit" })
map("n", "<leader>un", function() Snacks.notifier.hide() end, { desc = "Snacks: Dismiss All Notifications" })
map("n", "<c-/>", function() Snacks.terminal() end, { desc = "Snacks: Toggle Terminal" })
map("n", "<c-_>", function() Snacks.terminal() end, { desc = "which_key_ignore" })
map({ "n", "t" }, "]]", function() Snacks.words.jump(vim.v.count1) end, { desc = "Snacks: Next Reference" })
map({ "n", "t" }, "[[", function() Snacks.words.jump(-vim.v.count1) end, { desc = "Snacks: Prev Reference" })
