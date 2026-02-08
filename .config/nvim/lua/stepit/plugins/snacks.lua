return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = false },
		dashboard = { enabled = false },
		explorer = { enabled = false },
		indent = {
			indent = {
				enabled = true,
				char = require("stepit.utils.icons").lines.vertical.left,
				only_scope = false,
				hl = "VertSplit",
			},
			scope = {
				enabled = true,
				priority = 200,
				char = require("stepit.utils.icons").lines.vertical.left,
				underline = false,
				only_current = false,
				hl = "Special",
			},
		},
		input = { enabled = false },
		picker = { enabled = false },
		notifier = { enabled = false },
		quickfile = { enabled = false },
		scope = { enabled = false },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = false },
		image = {
			formats = { "png", "jpg", "jpeg", "gif", "webp", "tiff", "heic", "pdf" },
			force = false,
			doc = {
				-- enable image viewer for documents
				-- a treesitter parser must be available for the enabled languages.
				enabled = true,
				-- render the image inline in the buffer
				-- if your env doesn't support unicode placeholders, this will be disabled
				-- takes precedence over `opts.float` on supported terminals
				inline = true, -- Enable inline rendering
				-- render the image in a floating window
				-- only used if `opts.inline` is disabled
				float = false, -- Disable floating window
				max_width = 80,
				max_height = 40,
				-- Set to `true`, to conceal the image text when rendering inline.
				-- (experimental)
				---@param lang string tree-sitter language
				---@param type snacks.image.Type image type
				conceal = function(lang, type)
					-- Never auto-conceal - only manual trigger with <C-m>
					return false
				end,
			},
			img_dirs = { "img", "images", "assets", "static", "public", "media", "attachments" },
			-- window options applied to windows displaying image buffers
			-- an image buffer is a buffer with `filetype=image`
			wo = {
				wrap = false,
				number = false,
				relativenumber = false,
				cursorcolumn = false,
				signcolumn = "no",
				foldcolumn = "0",
				list = false,
				spell = false,
				statuscolumn = "",
			},
			cache = vim.fn.stdpath("cache") .. "/snacks/image",
			debug = {
				request = false,
				convert = false,
				placement = false,
			},
			env = {},
			-- icons used to show where an inline image is located that is
			-- rendered below the text.
			icons = {
				math = "󰪚 ",
				chart = "󰄧 ",
				image = " ",
			},
			convert = {
				notify = false, -- disable conversion error notifications
				mermaid = function()
					local theme = vim.o.background == "light" and "neutral" or "dark"
					return { "-i", "{src}", "-o", "{file}", "-b", "transparent", "-t", theme, "-s", "{scale}" }
				end,
				magick = {
					default = { "{src}[0]", "-scale", "1920x1080>" }, -- default for raster images
					vector = { "-density", 192, "{src}[0]" }, -- used by vector images like svg
					math = { "-density", 192, "{src}[0]", "-trim" },
					pdf = { "-density", 192, "{src}[0]", "-background", "white", "-alpha", "remove", "-trim" },
				},
			},
			math = {
				enabled = true,
				typst = {
					tpl = [[
        #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
        #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
        #set text(size: 12pt, fill: rgb("${color}"))
        ${header}
        ${content}]],
				},
				latex = {
					font_size = "Large", -- see https://www.sascha-frank.com/latex-font-size.html
					packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
					tpl = [[
        \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
        \usepackage{${packages}}
        \begin{document}
        ${header}
        { \${font_size} \selectfont
          \color[HTML]{${color}}
        ${content}}
        \end{document}]],
				},
			},
		},
	},
}
