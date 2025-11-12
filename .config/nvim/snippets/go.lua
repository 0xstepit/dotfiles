local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node

return {
	s("iferr", {
		t("if err != nil {"),
		t({ "", "\t" }),
		c(1, {
			t("return err"),
			t("log.Fatal(err)"),
			t("panic(err)"),
		}),
		t({ "", "}" }),
	}),
}
