-- clion_theme.lua (v7)
-- A high-fidelity Neovim theme attempting a 1:1 match with your CLion config.
-- This version correctly differentiates between local variables, parameters, and class members.

-- Set terminal colors for consistency in the built-in terminal.
vim.g.terminal_color_0 = "#2B2B2B"
vim.g.terminal_color_1 = "#FF6B68"
vim.g.terminal_color_2 = "#A9B7C6"
vim.g.terminal_color_3 = "#FFC66D"
vim.g.terminal_color_4 = "#6897BB"
vim.g.terminal_color_5 = "#CC7832"
vim.g.terminal_color_6 = "#9876AA"
vim.g.terminal_color_7 = "#A9B7C6"
vim.g.terminal_color_8 = "#808080"
vim.g.terminal_color_9 = "#FF6B68"
vim.g.terminal_color_10 = "#A9B7C6"
vim.g.terminal_color_11 = "#FFC66D"
vim.g.terminal_color_12 = "#6897BB"
vim.g.terminal_color_13 = "#CC7832"
vim.g.terminal_color_14 = "#9876AA"
vim.g.terminal_color_15 = "#FFFFFF"

-- Main function to apply all highlight groups.
local function apply_highlights()
    -- Reset existing syntax highlighting.
    if vim.fn.exists("syntax_on") then
        vim.cmd("syntax reset")
    end

    vim.o.background = "dark"
    vim.g.colors_name = "clion_inspired_v7"

    -- Helper function to set highlight groups cleanly.
    local function set_hl(group, styles)
        vim.api.nvim_set_hl(0, group, styles)
    end

    -- A more detailed color palette based on your .icls file and screenshots.
    local colors = {
        background = "#2c2c2c",  -- Editor background
        comment = "#808080",     -- Comments
        keyword = "#CC7832",     -- Keywords (if, for, const, etc.)
        string = "#6A8759",      -- String literals
        number = "#6897BB",      -- Numbers
		include = "#b7b429",

        func_call = "#FFC66D",
        struct_type = "#76A47F",
        namespace = "#87C3E5",
        global_var = "#c09658",
        preproc = "#8e8b25",
        typedef = "#B6AC2F",

        local_variable = "#a9b7c6",   -- As specified
        parameter = "#8bafee",        -- As specified
        member = "#9876AA",           -- Purple for class/struct members/attributes

        -- UI Colors
        ui_background = "#323232", -- Popups, cursorline background
        selection = "#214283",   -- Visual selection background
        error = "#FF6B68",       -- Error text

        plugin_border = "#316c71", -- Specific border color for Snacks and NvimTree
    }

    -- General UI Highlights
    set_hl("Normal", { fg = colors.local_variable, bg = colors.background }) -- Default text is the local var color
    set_hl("LineNr", { fg = colors.comment, bg = colors.background })
    set_hl("CursorLineNr", { fg = colors.local_variable, bg = colors.ui_background, bold = true })
    set_hl("CursorLine", { bg = colors.ui_background })
    set_hl("Visual", { bg = colors.selection })
    set_hl("ColorColumn", { bg = "#3A3A3A" })
    set_hl("SignColumn", { fg = colors.local_variable, bg = colors.background })
    set_hl("VertSplit", { fg = colors.comment, bg = colors.background })
    set_hl("StatusLine", { fg = colors.local_variable, bg = colors.ui_background })
    set_hl("StatusLineNC", { fg = colors.comment, bg = colors.background })
    set_hl("Pmenu", { fg = colors.local_variable, bg = colors.ui_background })
    set_hl("PmenuSel", { bg = colors.selection })
    set_hl("TabLine", { fg = colors.comment, bg = colors.background })
    set_hl("TabLineFill", { bg = colors.background, fg = colors.background }) -- This removes the line
    set_hl("TabLineFill", { bg = colors.background })
    set_hl("TabLineSel", { fg = colors.local_variable, bg = colors.ui_background })
    set_hl("Error", { fg = colors.error, bg = colors.background, bold = true })
    set_hl("Todo", { fg = colors.background, bg = colors.func_call, bold = true })
    -- set_hl("BufferLineSeparator", { fg = colors.background, bg = colors.background })
    -- set_hl("BufferLineSeparatorVisible", { fg = colors.background, bg = colors.background })
    -- set_hl("BufferLineSeparatorSelected", { fg = colors.background, bg = colors.background })
	set_hl("TabLineFill", { bg = colors.background })
    -- ==============================================================================
    -- === Detailed Treesitter Highlighting =========================================
    -- ==============================================================================

    set_hl("@comment", { fg = colors.comment, italic = true })
    set_hl("Comment", { link = "@comment" })
    set_hl("@keyword", { fg = colors.keyword })
    set_hl("@keyword.function", { fg = colors.keyword })
    set_hl("@boolean", { fg = colors.keyword, bold = true })
    set_hl("@string", { fg = colors.string })
    set_hl("@number", { fg = colors.number })
    set_hl("@operator", { fg = colors.operator })
    set_hl("@preproc", { fg = colors.preproc })
    set_hl("@keyword.import", { fg = colors.include })
    set_hl("@define", { fg = colors.include }) -- Ensures #define has the right color

    -- Functions
    set_hl("@function", { fg = colors.func_call })
    set_hl("@method", { fg = colors.func_call })
    set_hl("@constructor", { fg = colors.func_call })

    -- Types
    set_hl("@type", { fg = colors.struct_type })
    set_hl("@type.definition", { fg = colors.typedef })
    set_hl("@type.builtin", { fg = colors.keyword }) -- void, int, float, etc.
    set_hl("@namespace", { fg = colors.namespace, italic = true })

    -- === CORRECTED VARIABLE HIGHLIGHTING ===
    set_hl("@variable", { fg = colors.local_variable })
    set_hl("@variable.parameter", { fg = colors.parameter})
	set_hl("@variable.parameter.builtin", { fg = colors.parameter , bold = true })
    set_hl("@field", { fg = colors.member })
    set_hl("@property", { fg = colors.member })
    set_hl("@variable.member", { fg = colors.member })
    -- Global variables / Constants
    set_hl("@constant.macro", { fg = colors.preproc })
    set_hl("@constant", { fg = colors.global_var })
	-- vim.cmd("highlight! link @variable.global @variable.builtin")

    -- ==============================================================================
    -- === Plugin UI Highlighting ===================================================
    -- ==============================================================================

    -- Telescope
    set_hl("TelescopeNormal", { bg = colors.ui_background })
    set_hl("TelescopeBorder", { fg = colors.comment, bg = colors.ui_background })
    set_hl("TelescopePromptNormal", { fg = colors.local_variable, bg = colors.ui_background })
    set_hl("TelescopePromptBorder", { fg = colors.comment, bg = colors.ui_background })
    set_hl("TelescopeResultsNormal", { fg = colors.local_variable, bg = colors.ui_background })
    set_hl("TelescopeResultsBorder", { fg = colors.comment, bg = colors.ui_background })
    set_hl("TelescopePreviewNormal", { bg = colors.background })
    set_hl("TelescopePreviewBorder", { fg = colors.comment, bg = colors.background })
    set_hl("TelescopeSelection", { bg = colors.selection, fg = colors.local_variable })

	set_hl("NormalFloat", { bg = "none" })
    set_hl("FloatBorder", { fg = colors.plugin_border, bg = "none" })

    -- Snacks
    set_hl("SnacksPicker", { bg = "none", nocombine = true })
    set_hl("SnacksPickerBorder", { fg = colors.plugin_border, bg = "none", nocombine = true })
    vim.cmd("highlight! link SnacksNormal TelescopeNormal")
    vim.cmd("highlight! link SnacksBorder TelescopeBorder")
    vim.cmd("highlight! link SnacksSelection TelescopeSelection")
    set_hl("SnacksTitle", { bg = colors.ui_background, fg = colors.func_call })
    set_hl("SnacksWaiting", { fg = colors.comment })
    set_hl("SnacksMatch", { fg = colors.string, bold = true })
    set_hl("SnacksPopup", { bg = colors.background })

end

-- Apply the theme.
apply_highlights()
