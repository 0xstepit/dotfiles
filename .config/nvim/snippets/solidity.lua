local ls = require("luasnip")

local s = ls.snippet
local c = ls.choice_node
local t = ls.text_node
local i = ls.insert_node

local fmt = require("luasnip.extras.fmt").fmt

-- This can be used to add hi to snippets.
local ext_opts_choice = {}

-- Returns true if the node is part of an assembly statement block.
local function in_assembly()
	local has_parser, parser = pcall(vim.treesitter.get_parser, 0, "solidity")
	if not has_parser or parser == nil then
		return false
	end

	local cursor = vim.api.nvim_win_get_cursor(0)
	local row, col = cursor[1] - 1, cursor[2]

	local langs = parser:parse()
	if langs == nil then
		return false
	end

	local root = langs[1]:root()
	local node = root:descendant_for_range(row, col, row, col)

	while node do
		if node:type() == "assembly_statement" then
			return true
		end
		node = node:parent()
	end

	return false
end

return {
	-- ============================================================
	-- FORGE TEST SNIPPETS
	-- ============================================================

	-- Test contract template
	s(
		{ trig = "tcon", dscr = "Forge test contract" },
		fmt(
			[[
// SPDX-License-Identifier: {}
pragma solidity ^{};

import {{Test, console}} from "forge-std/Test.sol";
{}

contract {}Test is Test {{
	{}

	function setUp() public {{
		{}
	}}

	{}
}}
]],
			{
				i(1, "MIT"),
				i(2, "0.8.20"),
				i(3, '// import {...} from "...";'),
				i(4, "Contract"),
				i(5, "// state variables"),
				i(6, "// setup logic"),
				i(0),
			}
		)
	),

	-- Script contract template
	s(
		{ trig = "scon", dscr = "Forge script contract" },
		fmt(
			[[
// SPDX-License-Identifier: {}
pragma solidity ^{};

import {{Script, console}} from "forge-std/Script.sol";
{}

contract {}Script is Script {{
	function setUp() public {{}}

	function run() public {{
		vm.startBroadcast();

		{}

		vm.stopBroadcast();
	}}
}}
]],
			{
				i(1, "MIT"),
				i(2, "0.8.20"),
				i(3, '// import {...} from "...";'),
				i(4, "Deploy"),
				i(0),
			}
		)
	),

	-- setUp function
	s(
		{ trig = "setup", dscr = "setUp function" },
		fmt(
			[[
function setUp() public {{
	{}
}}
]],
			{ i(0) }
		)
	),

	-- Test function variants
	s({ trig = "tfn", dscr = "Test function" }, {
		t("function "),
		c(1, {
			{ t("test_"), i(1, "Description") },
			{ t("testFuzz_"), i(1, "Description") },
			{ t("testFork_"), i(1, "Description") },
			{ t("test_RevertWhen_"), i(1, "Condition") },
			{ t("test_RevertIf_"), i(1, "Condition") },
		}, { node_ext_opts = ext_opts_choice }),
		t("() public "),
		c(2, {
			t(""),
			t("view "),
		}),
		t({ "{", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	-- Fuzz test with parameters
	s(
		{ trig = "tfuzz", dscr = "Fuzz test function" },
		fmt(
			[[
function testFuzz_{}({}) public {{
	{}
	{}
}}
]],
			{
				i(1, "Description"),
				i(2, "uint256 x"),
				i(3, "// bound inputs"),
				i(0),
			}
		)
	),

	-- ============================================================
	-- FORGE ASSERTIONS
	-- ============================================================

	s({ trig = "aseq", dscr = "assertEq" }, {
		t("assertEq("),
		i(1, "actual"),
		t(", "),
		i(2, "expected"),
		c(3, {
			t(""),
			{ t(', "'), i(1, "message"), t('"') },
		}),
		t(");"),
	}),

	s({ trig = "asne", dscr = "assertNotEq" }, {
		t("assertNotEq("),
		i(1, "a"),
		t(", "),
		i(2, "b"),
		c(3, {
			t(""),
			{ t(', "'), i(1, "message"), t('"') },
		}),
		t(");"),
	}),

	s({ trig = "ast", dscr = "assertTrue" }, {
		t("assertTrue("),
		i(1, "condition"),
		c(2, {
			t(""),
			{ t(', "'), i(1, "message"), t('"') },
		}),
		t(");"),
	}),

	s({ trig = "asf", dscr = "assertFalse" }, {
		t("assertFalse("),
		i(1, "condition"),
		c(2, {
			t(""),
			{ t(', "'), i(1, "message"), t('"') },
		}),
		t(");"),
	}),

	s({ trig = "asgt", dscr = "assertGt" }, {
		t("assertGt("),
		i(1, "a"),
		t(", "),
		i(2, "b"),
		c(3, {
			t(""),
			{ t(', "'), i(1, "message"), t('"') },
		}),
		t(");"),
	}),

	s({ trig = "asge", dscr = "assertGe" }, {
		t("assertGe("),
		i(1, "a"),
		t(", "),
		i(2, "b"),
		c(3, {
			t(""),
			{ t(', "'), i(1, "message"), t('"') },
		}),
		t(");"),
	}),

	s({ trig = "aslt", dscr = "assertLt" }, {
		t("assertLt("),
		i(1, "a"),
		t(", "),
		i(2, "b"),
		c(3, {
			t(""),
			{ t(', "'), i(1, "message"), t('"') },
		}),
		t(");"),
	}),

	s({ trig = "asle", dscr = "assertLe" }, {
		t("assertLe("),
		i(1, "a"),
		t(", "),
		i(2, "b"),
		c(3, {
			t(""),
			{ t(', "'), i(1, "message"), t('"') },
		}),
		t(");"),
	}),

	s({ trig = "asapprox", dscr = "assertApproxEqAbs" }, {
		t("assertApproxEqAbs("),
		i(1, "actual"),
		t(", "),
		i(2, "expected"),
		t(", "),
		i(3, "maxDelta"),
		t(");"),
	}),

	s({ trig = "asapproxrel", dscr = "assertApproxEqRel" }, {
		t("assertApproxEqRel("),
		i(1, "actual"),
		t(", "),
		i(2, "expected"),
		t(", "),
		i(3, "maxPercentDelta"),
		t("); // 1e16 = 1%"),
	}),

	-- ============================================================
	-- FORGE VM CHEATS
	-- ============================================================

	-- Prank
	s({ trig = "prank", dscr = "vm.prank" }, {
		t("vm.prank("),
		i(1, "address"),
		t(");"),
	}),

	s(
		{ trig = "sprank", dscr = "vm.startPrank/stopPrank" },
		fmt(
			[[
vm.startPrank({});
{}
vm.stopPrank();
]],
			{
				i(1, "address"),
				i(0),
			}
		)
	),

	-- Expect revert
	s({ trig = "exrev", dscr = "vm.expectRevert" }, {
		t("vm.expectRevert("),
		c(1, {
			t(""),
			{ t("abi.encodeWithSelector("), i(1, "Error.selector"), t(")") },
			{ i(1, "Error.selector") },
			{ t('"'), i(1, "message"), t('"') },
		}, { node_ext_opts = ext_opts_choice }),
		t(");"),
	}),

	-- Expect emit
	s(
		{ trig = "exemit", dscr = "vm.expectEmit" },
		fmt(
			[[
vm.expectEmit({}, {}, {}, {});
emit {}({});
]],
			{
				i(1, "true"),
				i(2, "true"),
				i(3, "true"),
				i(4, "true"),
				i(5, "EventName"),
				i(6, "args"),
			}
		)
	),

	-- Deal
	s({ trig = "deal", dscr = "vm.deal" }, {
		t("vm.deal("),
		i(1, "address"),
		t(", "),
		i(2, "amount"),
		t(");"),
	}),

	-- Warp (time)
	s({ trig = "warp", dscr = "vm.warp" }, {
		t("vm.warp("),
		i(1, "timestamp"),
		t(");"),
	}),

	-- Roll (block)
	s({ trig = "roll", dscr = "vm.roll" }, {
		t("vm.roll("),
		i(1, "blockNumber"),
		t(");"),
	}),

	-- Fee
	s({ trig = "txfee", dscr = "vm.txGasPrice" }, {
		t("vm.txGasPrice("),
		i(1, "gasPrice"),
		t(");"),
	}),

	-- Label
	s({ trig = "label", dscr = "vm.label" }, {
		t("vm.label("),
		i(1, "address"),
		t(', "'),
		i(2, "name"),
		t('");'),
	}),

	-- Bound for fuzzing
	s({ trig = "bound", dscr = "bound value for fuzzing" }, {
		i(1, "x"),
		t(" = bound("),
		i(2, "x"),
		t(", "),
		i(3, "min"),
		t(", "),
		i(4, "max"),
		t(");"),
	}),

	-- Make address
	s({ trig = "mkaddr", dscr = "makeAddr" }, {
		t("address "),
		i(1, "user"),
		t(' = makeAddr("'),
		i(2, "user"),
		t('");'),
	}),

	-- Etch
	s({ trig = "etch", dscr = "vm.etch" }, {
		t("vm.etch("),
		i(1, "address"),
		t(", "),
		i(2, "code"),
		t(");"),
	}),

	-- Store
	s({ trig = "store", dscr = "vm.store" }, {
		t("vm.store("),
		i(1, "target"),
		t(", "),
		i(2, "slot"),
		t(", "),
		i(3, "value"),
		t(");"),
	}),

	-- Load
	s({ trig = "load", dscr = "vm.load" }, {
		t("vm.load("),
		i(1, "target"),
		t(", "),
		i(2, "slot"),
		t(")"),
	}),

	-- Snapshot
	s({ trig = "snap", dscr = "vm.snapshot" }, {
		t("uint256 "),
		i(1, "snapshotId"),
		t(" = vm.snapshot();"),
	}),

	s({ trig = "revert", dscr = "vm.revertTo" }, {
		t("vm.revertTo("),
		i(1, "snapshotId"),
		t(");"),
	}),

	-- Fork
	s({ trig = "fork", dscr = "vm.createFork" }, {
		t("uint256 "),
		i(1, "forkId"),
		t(' = vm.createFork(vm.envString("'),
		i(2, "RPC_URL"),
		t('")'),
		c(3, {
			t(""),
			{ t(", "), i(1, "blockNumber") },
		}),
		t(");"),
	}),

	s({ trig = "selfork", dscr = "vm.selectFork" }, {
		t("vm.selectFork("),
		i(1, "forkId"),
		t(");"),
	}),

	-- Record
	s({ trig = "record", dscr = "vm.record" }, {
		t("vm.record();"),
	}),

	s({ trig = "accesses", dscr = "vm.accesses" }, {
		t("(bytes32[] memory reads, bytes32[] memory writes) = vm.accesses("),
		i(1, "target"),
		t(");"),
	}),

	-- Broadcast
	s(
		{ trig = "broadcast", dscr = "vm.startBroadcast/stopBroadcast" },
		fmt(
			[[
vm.startBroadcast({});
{}
vm.stopBroadcast();
]],
			{
				c(1, {
					t(""),
					i(1, "privateKey"),
					i(1, "deployer"),
				}),
				i(0),
			}
		)
	),

	-- ============================================================
	-- CONSOLE LOG
	-- ============================================================

	s({ trig = "clog", dscr = "console.log" }, {
		t("console.log("),
		c(1, {
			i(1, "value"),
			{ t('"'), i(1, "message"), t('", '), i(2, "value") },
		}, { node_ext_opts = ext_opts_choice }),
		t(");"),
	}),

	s({ trig = "clogs", dscr = "console.logString" }, {
		t('console.log("'),
		i(1, "message"),
		t('");'),
	}),

	s({ trig = "clogu", dscr = "console.logUint" }, {
		t("console.logUint("),
		i(1, "value"),
		t(");"),
	}),

	s({ trig = "clogb", dscr = "console.logBytes32" }, {
		t("console.logBytes32("),
		i(1, "value"),
		t(");"),
	}),

	s({ trig = "cloga", dscr = "console.logAddress" }, {
		t("console.logAddress("),
		i(1, "address"),
		t(");"),
	}),

	-- ============================================================
	-- SOLIDITY PATTERNS
	-- ============================================================

	-- Contract template
	s(
		{ trig = "con", dscr = "Contract template" },
		fmt(
			[[
// SPDX-License-Identifier: {}
pragma solidity ^{};

contract {} {{
	{}
}}
]],
			{
				i(1, "MIT"),
				i(2, "0.8.20"),
				i(3, "MyContract"),
				i(0),
			}
		)
	),

	-- Interface
	s(
		{ trig = "iface", dscr = "Interface template" },
		fmt(
			[[
interface I{} {{
	{}
}}
]],
			{
				i(1, "Name"),
				i(0),
			}
		)
	),

	-- Library
	s(
		{ trig = "lib", dscr = "Library template" },
		fmt(
			[[
library {} {{
	{}
}}
]],
			{
				i(1, "Name"),
				i(0),
			}
		)
	),

	-- Event
	s({ trig = "event", dscr = "Event declaration" }, {
		t("event "),
		i(1, "Name"),
		t("("),
		i(2, "params"),
		t(");"),
	}),

	-- Custom error
	s({ trig = "err", dscr = "Custom error" }, {
		t("error "),
		i(1, "Name"),
		t("("),
		i(2),
		t(");"),
	}),

	-- Modifier
	s(
		{ trig = "mod", dscr = "Modifier" },
		fmt(
			[[
modifier {}({}) {{
	{}
	_;
}}
]],
			{
				i(1, "name"),
				i(2),
				i(0),
			}
		)
	),

	-- Constructor
	s(
		{ trig = "ctor", dscr = "Constructor" },
		fmt(
			[[
constructor({}) {{
	{}
}}
]],
			{
				i(1),
				i(0),
			}
		)
	),

	-- Function
	s({ trig = "fn", dscr = "Function" }, {
		t("function "),
		i(1, "name"),
		t("("),
		i(2),
		t(") "),
		c(3, {
			t("external"),
			t("public"),
			t("internal"),
			t("private"),
		}),
		t(" "),
		c(4, {
			t(""),
			t("view "),
			t("pure "),
			t("payable "),
		}),
		c(5, {
			t(""),
			{ t("returns ("), i(1, "type"), t(") ") },
		}),
		t({ "{", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	-- Receive
	s({ trig = "receive", dscr = "Receive function" }, {
		t({ "receive() external payable {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	-- Fallback
	s({ trig = "fallback", dscr = "Fallback function" }, {
		t({ "fallback() external payable {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	-- Mapping
	s({ trig = "map", dscr = "Mapping" }, {
		t("mapping("),
		i(1, "address"),
		t(" => "),
		i(2, "uint256"),
		t(") "),
		c(3, {
			t("public"),
			t("private"),
			t("internal"),
		}),
		t(" "),
		i(4, "name"),
		t(";"),
	}),

	-- Struct
	s(
		{ trig = "struct", dscr = "Struct" },
		fmt(
			[[
struct {} {{
	{}
}}
]],
			{
				i(1, "Name"),
				i(0),
			}
		)
	),

	-- Enum
	s(
		{ trig = "enum", dscr = "Enum" },
		fmt(
			[[
enum {} {{
	{}
}}
]],
			{
				i(1, "Name"),
				i(0),
			}
		)
	),

	-- Require
	s({ trig = "req", dscr = "require" }, {
		t("require("),
		i(1, "condition"),
		t(', "'),
		i(2, "message"),
		t('");'),
	}),

	-- Revert with error
	s({ trig = "rev", dscr = "revert with error" }, {
		t("revert "),
		i(1, "Error"),
		t("("),
		i(2),
		t(");"),
	}),

	-- If/revert pattern
	s(
		{ trig = "ifrev", dscr = "if condition revert" },
		fmt(
			[[
if ({}) revert {}({});
]],
			{
				i(1, "condition"),
				i(2, "Error"),
				i(3),
			}
		)
	),

	-- Import
	s({ trig = "imp", dscr = "Import" }, {
		t("import {"),
		i(1, "Name"),
		t('} from "'),
		i(2, "path"),
		t('";'),
	}),

	-- SPDX + pragma
	s({ trig = "spdx", dscr = "SPDX + pragma" }, {
		t("// SPDX-License-Identifier: "),
		i(1, "MIT"),
		t({ "", "pragma solidity ^" }),
		i(2, "0.8.20"),
		t(";"),
	}),

	-- Using for
	s({ trig = "using", dscr = "Using for" }, {
		t("using "),
		i(1, "Library"),
		t(" for "),
		i(2, "Type"),
		t(";"),
	}),

	-- ============================================================
	-- COMMON VALUES
	-- ============================================================

	s({ trig = "f32", dscr = "32 bytes of 1s (type(uint256).max)" }, {
		t("0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff"),
	}),

	s({ trig = "z32", dscr = "32 bytes of 0s" }, {
		t("0x0000000000000000000000000000000000000000000000000000000000000000"),
	}),

	s({ trig = "maxu256", dscr = "type(uint256).max" }, {
		t("type(uint256).max"),
	}),

	s({ trig = "maxu128", dscr = "type(uint128).max" }, {
		t("type(uint128).max"),
	}),

	s({ trig = "ether", dscr = "ether value" }, {
		i(1, "1"),
		t(" ether"),
	}),

	s({ trig = "gwei", dscr = "gwei value" }, {
		i(1, "1"),
		t(" gwei"),
	}),

	s({ trig = "days", dscr = "days value" }, {
		i(1, "1"),
		t(" days"),
	}),

	s({ trig = "hours", dscr = "hours value" }, {
		i(1, "1"),
		t(" hours"),
	}),

	-- Keccak256
	s("kec", {
		t("keccak256("),
		c(1, {
			i(nil, "value"),
			{ t("abi.encode("), i(1, "value"), t(")") },
			{ t("abi.encodePacked("), i(1, "value"), t(")") },
		}, { node_ext_opts = ext_opts_choice }),
		t(")"),
	}),

	-- ============================================================
	-- ASSEMBLY / YUL
	-- ============================================================

	s(
		{ trig = "assembly", dscr = "assembly block" },
		fmt(
			[[
assembly {{
	{}
}}
]],
			{ i(0) }
		)
	),

	s(
		{ trig = "asmm", dscr = "assembly memory-safe block" },
		fmt(
			[[
assembly ("memory-safe") {{
	{}
}}
]],
			{ i(0) }
		)
	),

	s({ trig = "pop", dscr = "pop function", show_condition = in_assembly }, {
		t("pop("),
		i(1),
		t(")"),
	}),

	s({ trig = "mload", dscr = "mload function", show_condition = in_assembly }, {
		t("mload("),
		i(1),
		t(")"),
	}),

	s({ trig = "mstore", dscr = "mstore function", show_condition = in_assembly }, {
		t("mstore("),
		i(1, "offset"),
		t(", "),
		i(2, "value"),
		t(")"),
	}),

	s({ trig = "sload", dscr = "sload function", show_condition = in_assembly }, {
		t("sload("),
		i(1),
		t(")"),
	}),

	s({ trig = "sstore", dscr = "sstore function", show_condition = in_assembly }, {
		t("sstore("),
		i(1, "slot"),
		t(", "),
		i(2, "value"),
		t(")"),
	}),

	s({ trig = "calldataload", dscr = "calldataload function", show_condition = in_assembly }, {
		t("calldataload("),
		i(1),
		t(")"),
	}),

	s({ trig = "calldatacopy", dscr = "calldatacopy function", show_condition = in_assembly }, {
		t("calldatacopy("),
		i(1, "destOffset"),
		t(", "),
		i(2, "offset"),
		t(", "),
		i(3, "size"),
		t(")"),
	}),

	s({ trig = "returndatasize", dscr = "returndatasize", show_condition = in_assembly }, {
		t("returndatasize()"),
	}),

	s({ trig = "returndatacopy", dscr = "returndatacopy function", show_condition = in_assembly }, {
		t("returndatacopy("),
		i(1, "destOffset"),
		t(", "),
		i(2, "offset"),
		t(", "),
		i(3, "size"),
		t(")"),
	}),

	s({ trig = "call", dscr = "call function", show_condition = in_assembly }, {
		t("call("),
		i(1, "gas"),
		t(", "),
		i(2, "address"),
		t(", "),
		i(3, "value"),
		t(", "),
		i(4, "argsOffset"),
		t(", "),
		i(5, "argsSize"),
		t(", "),
		i(6, "retOffset"),
		t(", "),
		i(7, "retSize"),
		t(")"),
	}),

	s({ trig = "staticcall", dscr = "staticcall function", show_condition = in_assembly }, {
		t("staticcall("),
		i(1, "gas"),
		t(", "),
		i(2, "address"),
		t(", "),
		i(3, "argsOffset"),
		t(", "),
		i(4, "argsSize"),
		t(", "),
		i(5, "retOffset"),
		t(", "),
		i(6, "retSize"),
		t(")"),
	}),

	s({ trig = "delegatecall", dscr = "delegatecall function", show_condition = in_assembly }, {
		t("delegatecall("),
		i(1, "gas"),
		t(", "),
		i(2, "address"),
		t(", "),
		i(3, "argsOffset"),
		t(", "),
		i(4, "argsSize"),
		t(", "),
		i(5, "retOffset"),
		t(", "),
		i(6, "retSize"),
		t(")"),
	}),

	s({ trig = "revert", dscr = "revert in assembly", show_condition = in_assembly }, {
		t("revert("),
		i(1, "offset"),
		t(", "),
		i(2, "size"),
		t(")"),
	}),

	s({ trig = "return", dscr = "return in assembly", show_condition = in_assembly }, {
		t("return("),
		i(1, "offset"),
		t(", "),
		i(2, "size"),
		t(")"),
	}),

	s({ trig = "let", dscr = "let declaration", show_condition = in_assembly }, {
		t("let "),
		i(1, "name"),
		t(" := "),
		i(2, "value"),
	}),

	s({ trig = "iszero", dscr = "iszero check", show_condition = in_assembly }, {
		t("iszero("),
		i(1),
		t(")"),
	}),

	s({ trig = "if", dscr = "if statement", show_condition = in_assembly }, {
		t("if "),
		i(1, "condition"),
		t({ " {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	s({ trig = "for", dscr = "for loop", show_condition = in_assembly }, {
		t("for { let "),
		i(1, "i"),
		t(" := "),
		i(2, "0"),
		t(" } lt("),
		i(3, "i"),
		t(", "),
		i(4, "n"),
		t(") { "),
		i(5, "i"),
		t(" := add("),
		i(6, "i"),
		t(", "),
		i(7, "1"),
		t({ ") } {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	s({ trig = "switch", dscr = "switch statement", show_condition = in_assembly }, {
		t("switch "),
		i(1, "value"),
		t({ "", "case 0 {", "\t" }),
		i(2),
		t({ "", "}", "default {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	s({ trig = "slot", dscr = "variable's slot value", show_condition = in_assembly }, {
		t("slot"),
	}),

	s({ trig = "offset", dscr = "variable's offset value", show_condition = in_assembly }, {
		t("offset"),
	}),

	s({ trig = "caller", dscr = "caller()", show_condition = in_assembly }, {
		t("caller()"),
	}),

	s({ trig = "callvalue", dscr = "callvalue()", show_condition = in_assembly }, {
		t("callvalue()"),
	}),

	s({ trig = "timestamp", dscr = "timestamp()", show_condition = in_assembly }, {
		t("timestamp()"),
	}),

	s({ trig = "number", dscr = "number() - block number", show_condition = in_assembly }, {
		t("number()"),
	}),

	s({ trig = "gas", dscr = "gas()", show_condition = in_assembly }, {
		t("gas()"),
	}),

	s({ trig = "keccak", dscr = "keccak256 in assembly", show_condition = in_assembly }, {
		t("keccak256("),
		i(1, "offset"),
		t(", "),
		i(2, "size"),
		t(")"),
	}),

	s({ trig = "add", dscr = "add", show_condition = in_assembly }, {
		t("add("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "sub", dscr = "sub", show_condition = in_assembly }, {
		t("sub("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "mul", dscr = "mul", show_condition = in_assembly }, {
		t("mul("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "div", dscr = "div", show_condition = in_assembly }, {
		t("div("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "mod", dscr = "mod", show_condition = in_assembly }, {
		t("mod("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "and", dscr = "and", show_condition = in_assembly }, {
		t("and("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "or", dscr = "or", show_condition = in_assembly }, {
		t("or("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "xor", dscr = "xor", show_condition = in_assembly }, {
		t("xor("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "not", dscr = "not", show_condition = in_assembly }, {
		t("not("),
		i(1),
		t(")"),
	}),

	s({ trig = "shl", dscr = "shl (shift left)", show_condition = in_assembly }, {
		t("shl("),
		i(1, "shift"),
		t(", "),
		i(2, "value"),
		t(")"),
	}),

	s({ trig = "shr", dscr = "shr (shift right)", show_condition = in_assembly }, {
		t("shr("),
		i(1, "shift"),
		t(", "),
		i(2, "value"),
		t(")"),
	}),

	s({ trig = "sar", dscr = "sar (arithmetic shift right)", show_condition = in_assembly }, {
		t("sar("),
		i(1, "shift"),
		t(", "),
		i(2, "value"),
		t(")"),
	}),

	s({ trig = "byte", dscr = "byte extraction", show_condition = in_assembly }, {
		t("byte("),
		i(1, "index"),
		t(", "),
		i(2, "value"),
		t(")"),
	}),

	s({ trig = "lt", dscr = "lt (less than)", show_condition = in_assembly }, {
		t("lt("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "gt", dscr = "gt (greater than)", show_condition = in_assembly }, {
		t("gt("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "eq", dscr = "eq (equal)", show_condition = in_assembly }, {
		t("eq("),
		i(1),
		t(", "),
		i(2),
		t(")"),
	}),

	s({ trig = "extcodesize", dscr = "extcodesize", show_condition = in_assembly }, {
		t("extcodesize("),
		i(1, "address"),
		t(")"),
	}),

	s({ trig = "balance", dscr = "balance", show_condition = in_assembly }, {
		t("balance("),
		i(1, "address"),
		t(")"),
	}),

	s({ trig = "selfbalance", dscr = "selfbalance", show_condition = in_assembly }, {
		t("selfbalance()"),
	}),

	s({ trig = "create", dscr = "create contract", show_condition = in_assembly }, {
		t("create("),
		i(1, "value"),
		t(", "),
		i(2, "offset"),
		t(", "),
		i(3, "size"),
		t(")"),
	}),

	s({ trig = "create2", dscr = "create2 contract", show_condition = in_assembly }, {
		t("create2("),
		i(1, "value"),
		t(", "),
		i(2, "offset"),
		t(", "),
		i(3, "size"),
		t(", "),
		i(4, "salt"),
		t(")"),
	}),

	-- Field (kept for backward compatibility)
	s("field", {
		i(1, "type"),
		t(" "),
		i(2, "name"),
		t(";"),
	}),
}
