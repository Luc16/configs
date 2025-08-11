local telescope = require('telescope')
local actions = require('telescope.actions')

local focus_preview = function(prompt_bufnr)
                local action_state = require("telescope.actions.state")
                local picker = action_state.get_current_picker(prompt_bufnr)
                local prompt_win = picker.prompt_win
                local previewer = picker.previewer
                local winid = previewer.state.winid
                local bufnr = previewer.state.bufnr
                vim.keymap.set("n", "<Tab>", function()
                    vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", prompt_win))
                end, { buffer = bufnr })
                vim.cmd(string.format("noautocmd lua vim.api.nvim_set_current_win(%s)", winid))
                -- api.nvim_set_current_win(winid)
            end

local function toggle_telescope_focus()
  local ts_win = require('telescope.windows')
  local is_results = ts_win.is_results_win(0)
  local is_preview = ts_win.is_preview_win(0)

  if is_results then
    -- If we are in the results window, jump to the preview window
    ts_win.focus_previewer()
  elseif is_preview then
    -- If we are in the preview window, jump back to the results
    ts_win.focus_results()
  end
end

telescope.setup({
  defaults = {
    -- Default layout is 'vertical'
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
        preview_width = 0.55,
      },
      vertical = {
        mirror = false,
      },
    },
    -- Other defaults
    file_sorter = require('telescope.sorters').get_fzy_sorter,
    generic_sorter = require('telescope.sorters').get_generic_fuzzy_sorter,
    path_display = { 'truncate' },
    winblend = 0,
    border = {},
    borderchars = { '─', '│', '─', '│', '╭', '╮', '╯', '╰' },
    color_devicons = true,
    use_less = true,
    set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
    file_previewer = require('telescope.previewers').vim_buffer_cat.new,
    grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
    qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

    -- Custom keymappings for the Telescope window
    mappings = {
      i = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
        ['<CR>'] = actions.select_default,
      },
      n = {
        ['<C-j>'] = actions.move_selection_next,
        ['<C-k>'] = actions.move_selection_previous,
        ['<C-q>'] = actions.send_to_qflist + actions.open_qflist,
		['l'] = toggle_telescope_focus,
      },
    },
  },
})

vim.schedule(function()
    require('telescope').load_extension('session-lens')
	require('telescope').load_extension('bibtex')
end)
-- === Keymaps for triggering Telescope ===
local builtin = require('telescope.builtin')
local nmap = function(keys, func, desc)
  vim.keymap.set('n', keys, func, { desc = desc, noremap = true, silent = true })
end

nmap('<leader>ff', builtin.find_files, 'Telescope: Find files')
nmap('<leader>fg', builtin.live_grep, 'Telescope: Live grep (text in files)')
nmap('<leader>fb', builtin.buffers, 'Telescope: Find open buffers')
nmap('<leader>fh', builtin.help_tags, 'Telescope: Find help tags')
