return {
	"folke/tokyonight.nvim",
	-- "solarized-berlin.nvim",
	-- dev = true,
	name = "Solarized Berlin",
	lazy = false,
	priority = 1000,
	opts = {},
	config = function()
		require("tokyonight").setup({
			-- style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
			-- light_style = "day", -- The theme is used when the background is set to light
			transparent = true,
			tokyonight_dark_float = false,
			styles = {
				sidebars = "transparent",
				floats = "transparent",
			},
		})
		vim.cmd("colorscheme tokyonight")
		-- Override colorscheme colors
		vim.api.nvim_set_hl(0, "CursorLine", { bg = "#293b3d" })
		vim.api.nvim_set_hl(0, "Cursor", { bg = "#fd3f92", fg = "#1e1e1e" })
		-- vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
		-- vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
	end,
}

-- return {
-- 		-- Colors table
-- 		-- local C = {}
-- 		-- C.black = "#1e1e1e"
-- 		-- C.grey = "#252525"
-- 		-- C.white = "#ffffff"
-- 		-- C.blue = "#4293f7"
-- 		-- C.purple = "#a370f7"
-- 		-- C.pink = "#b3409b"
-- 		-- C.red = "#d6537b"
-- 		-- C.turquoise = "#67c9ca"
-- 		-- C.persianGreen = "#00A693"
-- 		-- C.strongCyan = "#00add8"
-- 		-- C.frenchFuchsia = "#FD3F92"
-- 		-- C.veryDarkBlue = "#0f232b"
-- 		-- C.darkModerateCyan = "#296873"
-- 		-- C.amber = "#FFBF00"
-- 		-- C.steelBlue = "#4682B4"
-- 		-- C.limeGreen = "#65cdb3"
-- 		-- C.softBlue = "#5495fb"
-- 		--
-- 		-- -- Background
-- 		-- vim.api.nvim_set_hl(0, "Normal", { bg = C.black })
-- 		-- -- Column with line numbers on the left
-- 		-- vim.api.nvim_set_hl(0, "LineNr", { link = "Normal" })
-- 		-- vim.api.nvim_set_hl(0, "CursorLine", { link = "Normal" })
-- 		-- vim.api.nvim_set_hl(0, "CursorColumn", { link = "Normal" })
-- 		-- -- Column with git signs on the left
-- 		-- vim.api.nvim_set_hl(0, "SignColumn", { link = "Normal" })
-- 		-- -- Non text element like white spaces, tabs, ..
-- 		-- vim.api.nvim_set_hl(0, "NonText", { bg = C.black, fg = C.lightblue })
-- 		-- -- Column on the right
-- 		-- vim.api.nvim_set_hl(0, "ColorColumn", { bg = C.grey })
-- 		-- vim.api.nvim_set_hl(0, "Function", { fg = C.purple })
-- 		-- vim.api.nvim_set_hl(0, "String", { fg = C.persianGreen })
-- 		-- -- Netrw directories
-- 		-- vim.api.nvim_set_hl(0, "Directory", { link = "String" })
-- 		-- vim.api.nvim_set_hl(0, "Identifier", { fg = C.white })
-- 		-- vim.api.nvim_set_hl(0, "Statement", { fg = C.red })
-- 		-- vim.api.nvim_set_hl(0, "Operator", { fg = C.red })
-- 		-- vim.api.nvim_set_hl(0, "Special", { fg = C.softBlue, bg = C.black })
-- 		-- vim.api.nvim_set_hl(0, "Type", { fg = C.turquoise })
-- 		-- vim.api.nvim_set_hl(0, "Structure", { fg = C.purple })
-- 		-- vim.api.nvim_set_hl(0, "Comment", { fg = C.darkModerateCyan })
-- 		-- vim.api.nvim_set_hl(0, "NonText", { link = "Comment" })
-- 		-- vim.api.nvim_set_hl(0, "Search", { bg = C.purple, fg = C.black })
-- 		--
-- 		-- -- Gitsign
-- 		-- vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = C.black, fg = C.persianGreen })
-- 		-- vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = C.black, fg = C.red })
-- 		-- vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = C.black, fg = C.red })
-- 		-- vim.api.nvim_set_hl(0, "GitSignsChange", { bg = C.black, fg = C.amber })
-- 		-- vim.api.nvim_set_hl(0, "GitSignsChangedelete", { link = "GitSignsChange" })
-- 	end,
-- }
