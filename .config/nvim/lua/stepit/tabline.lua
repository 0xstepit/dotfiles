-- In your Neovim config
function _G.custom_tabline()
	local s = ""
	for i = 1, vim.fn.tabpagenr("$") do
		-- Select highlight group
		if i == vim.fn.tabpagenr() then
			s = s .. "%#TabLineSel#"
		else
			s = s .. "%#TabLine#"
		end

		-- Set the tab page number (for mouse clicks)
		s = s .. "%" .. i .. "T"

		-- Get tab name (customize this part)
		local tab_name = "Tab " .. i

		-- You can customize based on buffer in tab
		local buflist = vim.fn.tabpagebuflist(i)
		local winnr = vim.fn.tabpagewinnr(i)
		local bufnr = buflist[winnr]
		local bufname = vim.fn.bufname(bufnr)

		if bufname ~= "" then
			tab_name = vim.fn.fnamemodify(bufname, ":t") -- Just filename
		end

		s = s .. " " .. tab_name .. " "
	end

	s = s .. "%#TabLineFill#%T"
	return s
end

vim.o.tabline = "%!v:lua.custom_tabline()"
