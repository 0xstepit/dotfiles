local lopt = vim.opt_local

-- Indentation
lopt.shiftwidth = 4
lopt.tabstop = 4
lopt.expandtab = true

-- Folding based on treesitter
lopt.foldmethod = "expr"
lopt.foldexpr = "nvim_treesitter#foldexpr()"
lopt.foldlevel = 99

-- Comment string for Solidity
lopt.commentstring = "// %s"

-- Helper function to run forge commands in a terminal
local function forge_cmd(cmd, opts)
	opts = opts or {}
	local root = vim.fs.root(0, { "foundry.toml" })
	if not root then
		vim.notify("Not in a Foundry project (no foundry.toml found)", vim.log.levels.WARN)
		return
	end

	local full_cmd = "cd " .. vim.fn.shellescape(root) .. " && " .. cmd

	if opts.float then
		-- Open in floating terminal using snacks if available
		local ok, snacks = pcall(require, "snacks")
		if ok and snacks.terminal then
			snacks.terminal(full_cmd, { cwd = root })
		else
			vim.cmd("split | terminal " .. full_cmd)
		end
	else
		vim.cmd("split | terminal " .. full_cmd)
	end
end

-- Get the test function name under cursor (searches upward from cursor)
local function get_test_function_at_cursor()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]

	-- Search upward from cursor to find function definition
	for line_nr = row, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(0, line_nr - 1, line_nr, false)[1]
		if line then
			-- Match: function testSomething( or function test_Something(
			local func_name = line:match("function%s+(test[%w_]+)%s*%(")
			if func_name then
				return func_name
			end
			-- Stop if we hit another function that's not a test (we've gone too far)
			if line:match("function%s+[%w_]+%s*%(") and not line:match("function%s+test") then
				break
			end
			-- Stop if we hit contract/interface/library declaration
			if line:match("^%s*contract%s+") or line:match("^%s*interface%s+") or line:match("^%s*library%s+") then
				break
			end
		end
	end
	return nil
end

-- Get the contract name (finds the contract containing the cursor)
local function get_contract_name()
	local cursor = vim.api.nvim_win_get_cursor(0)
	local row = cursor[1]

	-- Search upward from cursor to find contract declaration
	for line_nr = row, 1, -1 do
		local line = vim.api.nvim_buf_get_lines(0, line_nr - 1, line_nr, false)[1]
		if line then
			-- Match: contract ContractName or contract ContractName is
			local contract_name = line:match("^%s*contract%s+([%w_]+)")
			if contract_name then
				return contract_name
			end
		end
	end

	-- Fallback: search entire file for first contract
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	for _, line in ipairs(lines) do
		local contract_name = line:match("^%s*contract%s+([%w_]+)")
		if contract_name then
			return contract_name
		end
	end

	return nil
end

-- Get relative path from foundry root
local function get_relative_path()
	local root = vim.fs.root(0, { "foundry.toml" })
	if not root then
		return nil
	end
	local file = vim.fn.expand("%:p")
	return file:sub(#root + 2) -- +2 to skip the trailing slash
end

-- Keybindings for Forge commands (buffer-local)
local function map(mode, lhs, rhs, desc)
	vim.keymap.set(mode, lhs, rhs, { buffer = true, desc = desc })
end

-- Build
map("n", "<leader>sb", function()
	forge_cmd("forge build")
end, "[S]olidity [B]uild")

-- Test all
map("n", "<leader>st", function()
	forge_cmd("forge test -vvv")
end, "[S]olidity [T]est all")

-- Test current file
map("n", "<leader>sT", function()
	local path = get_relative_path()
	if path then
		forge_cmd("forge test --match-path " .. vim.fn.shellescape(path) .. " -vvv")
	else
		vim.notify("Could not determine file path", vim.log.levels.WARN)
	end
end, "[S]olidity [T]est current file")

-- Test function under cursor
map("n", "<leader>sf", function()
	local test_name = get_test_function_at_cursor()
	if test_name then
		forge_cmd("forge test --match-test " .. test_name .. " -vvv")
	else
		vim.notify("No test function found under cursor", vim.log.levels.WARN)
	end
end, "[S]olidity test [F]unction under cursor")

-- Test with contract match
map("n", "<leader>sc", function()
	local contract = get_contract_name()
	if contract then
		forge_cmd("forge test --match-contract " .. contract .. " -vvv")
	else
		vim.notify("Could not determine contract name", vim.log.levels.WARN)
	end
end, "[S]olidity test [C]ontract")

-- Coverage
map("n", "<leader>sC", function()
	forge_cmd("forge coverage")
end, "[S]olidity [C]overage")

-- Gas report
map("n", "<leader>sg", function()
	forge_cmd("forge test --gas-report")
end, "[S]olidity [G]as report")

-- Snapshot
map("n", "<leader>ss", function()
	forge_cmd("forge snapshot")
end, "[S]olidity [S]napshot")

-- Snapshot diff
map("n", "<leader>sS", function()
	forge_cmd("forge snapshot --diff")
end, "[S]olidity [S]napshot diff")

-- Clean
map("n", "<leader>sx", function()
	forge_cmd("forge clean")
end, "[S]olidity clean")

-- Format (using forge fmt)
map("n", "<leader>sF", function()
	forge_cmd("forge fmt")
end, "[S]olidity [F]ormat project")

-- Inspect storage layout
map("n", "<leader>si", function()
	local contract = get_contract_name()
	if contract then
		forge_cmd("forge inspect " .. contract .. " storage-layout --pretty")
	else
		vim.notify("Could not determine contract name", vim.log.levels.WARN)
	end
end, "[S]olidity [I]nspect storage layout")

-- Inspect ABI
map("n", "<leader>sa", function()
	local contract = get_contract_name()
	if contract then
		forge_cmd("forge inspect " .. contract .. " abi --pretty")
	else
		vim.notify("Could not determine contract name", vim.log.levels.WARN)
	end
end, "[S]olidity inspect [A]BI")

-- Inspect methods
map("n", "<leader>sm", function()
	local contract = get_contract_name()
	if contract then
		forge_cmd("forge inspect " .. contract .. " methods --pretty")
	else
		vim.notify("Could not determine contract name", vim.log.levels.WARN)
	end
end, "[S]olidity inspect [M]ethods")

-- Run script
map("n", "<leader>sr", function()
	local path = get_relative_path()
	if path and path:match("^script/") then
		forge_cmd("forge script " .. vim.fn.shellescape(path) .. " -vvv")
	else
		vim.notify("Not in a script file (must be in script/ directory)", vim.log.levels.WARN)
	end
end, "[S]olidity [R]un script")

-- Test with fork
map("n", "<leader>sk", function()
	vim.ui.input({ prompt = "RPC URL env var (e.g., MAINNET_RPC_URL): " }, function(input)
		if input and input ~= "" then
			local test_name = get_test_function_at_cursor()
			local cmd = "forge test --fork-url $" .. input .. " -vvv"
			if test_name then
				cmd = cmd .. " --match-test " .. test_name
			end
			forge_cmd(cmd)
		end
	end)
end, "[S]olidity test with for[K]")

-- Debug test (opens debugger)
map("n", "<leader>sd", function()
	local test_name = get_test_function_at_cursor()
	if test_name then
		forge_cmd("forge test --debug " .. test_name)
	else
		vim.notify("No test function found under cursor", vim.log.levels.WARN)
	end
end, "[S]olidity [D]ebug test")

-- Trace test
map("n", "<leader>sv", function()
	local test_name = get_test_function_at_cursor()
	if test_name then
		forge_cmd("forge test --match-test " .. test_name .. " -vvvvv")
	else
		forge_cmd("forge test -vvvvv")
	end
end, "[S]olidity test with full [V]erbosity")

-- Create user commands for Forge
vim.api.nvim_buf_create_user_command(0, "ForgeBuild", function()
	forge_cmd("forge build")
end, { desc = "Run forge build" })

vim.api.nvim_buf_create_user_command(0, "ForgeTest", function(opts)
	local args = opts.args ~= "" and opts.args or "-vvv"
	forge_cmd("forge test " .. args)
end, { desc = "Run forge test", nargs = "*" })

vim.api.nvim_buf_create_user_command(0, "ForgeSnapshot", function(opts)
	local args = opts.args ~= "" and opts.args or ""
	forge_cmd("forge snapshot " .. args)
end, { desc = "Run forge snapshot", nargs = "*" })

vim.api.nvim_buf_create_user_command(0, "ForgeCoverage", function(opts)
	local args = opts.args ~= "" and opts.args or ""
	forge_cmd("forge coverage " .. args)
end, { desc = "Run forge coverage", nargs = "*" })

vim.api.nvim_buf_create_user_command(0, "ForgeScript", function(opts)
	if opts.args == "" then
		vim.notify("Usage: ForgeScript <script-path> [args...]", vim.log.levels.WARN)
		return
	end
	forge_cmd("forge script " .. opts.args .. " -vvv")
end, { desc = "Run forge script", nargs = "+" })

vim.api.nvim_buf_create_user_command(0, "ForgeInspect", function(opts)
	local args = vim.split(opts.args, " ")
	if #args < 2 then
		vim.notify("Usage: ForgeInspect <contract> <what> (e.g., ForgeInspect MyContract storage-layout)", vim.log.levels.WARN)
		return
	end
	forge_cmd("forge inspect " .. opts.args .. " --pretty")
end, { desc = "Run forge inspect", nargs = "+" })

vim.api.nvim_buf_create_user_command(0, "ForgeGas", function()
	forge_cmd("forge test --gas-report")
end, { desc = "Run forge test with gas report" })

vim.api.nvim_buf_create_user_command(0, "ForgeClean", function()
	forge_cmd("forge clean")
end, { desc = "Run forge clean" })
