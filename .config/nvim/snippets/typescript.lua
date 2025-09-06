local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

return {
  -- Function snippets
  s("func", {
    c(1, {
      { t("function "), i(1, "name"), t("("), i(2), t("): "), i(3, "void"), t(" {") },
      { t("const "), i(1, "name"), t(" = ("), i(2), t("): "), i(3, "void"), t(" => {") },
      { t("async function "), i(1, "name"), t("("), i(2), t("): Promise<"), i(3, "void"), t("> {") },
      { t("const "), i(1, "name"), t(" = async ("), i(2), t("): Promise<"), i(3, "void"), t("> => {") },
    }),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("af", {
    t("const "), i(1, "name"), t(" = ("), i(2), t("): "), i(3, "void"), t(" => {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("afn", {
    t("("), i(1), t("): "), i(2, "void"), t(" => {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("async", {
    t("async "), i(1, "function"), t("("), i(2), t("): Promise<"), i(3, "void"), t("> {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  -- TypeScript-specific
  s("int", {
    t("interface "), i(1, "InterfaceName"), t(" {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("type", {
    t("type "), i(1, "TypeName"), t(" = "), i(0),
  }),

  s("enum", {
    t("enum "), i(1, "EnumName"), t(" {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("class", {
    t("class "), i(1, "ClassName"), c(2, {
      t(""),
      { t(" extends "), i(1, "BaseClass") },
      { t(" implements "), i(1, "Interface") },
    }), t(" {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("ctor", {
    t("constructor("), i(1), t(") {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  -- React snippets
  s("rfc", {
    t("import React from 'react';"),
    t({"", ""}),
    t("interface "), i(1, "ComponentName"), t("Props {"),
    t({"", "\t"}), i(2),
    t({"", "}"}),
    t({"", ""}),
    t("const "), f(function(args) return args[1][1] end, {1}), t(": React.FC<"), f(function(args) return args[1][1] end, {1}), t("Props> = ("), i(3, "props"), t(") => {"),
    t({"", "\treturn ("}),
    t({"", "\t\t"}), i(0),
    t({"", "\t);"}),
    t({"", "};"}),
    t({"", ""}),
    t("export default "), f(function(args) return args[1][1] end, {1}), t(";"),
  }),

  s("usestate", {
    t("const ["), i(1, "state"), t(", set"), f(function(args) 
      local state = args[1][1]
      return state:gsub("^%l", string.upper)
    end, {1}), t("] = useState"), c(2, {
      { t("<"), i(1, "type"), t(">("), i(2, "initialValue"), t(")") },
      { t("("), i(1, "initialValue"), t(")") },
    }), t(";"),
  }),

  s("useeffect", {
    t("useEffect(() => {"),
    t({"", "\t"}), i(0),
    t({"", "}, ["), i(1), t("]);"),
  }),

  s("usecallback", {
    t("const "), i(1, "memoizedCallback"), t(" = useCallback(() => {"),
    t({"", "\t"}), i(0),
    t({"", "}, ["), i(2), t("]);"),
  }),

  s("usememo", {
    t("const "), i(1, "memoizedValue"), t(" = useMemo(() => {"),
    t({"", "\t"}), i(0),
    t({"", "}, ["), i(2), t("]);"),
  }),

  -- Variables and constants
  s("const", {
    t("const "), i(1, "name"), c(2, {
      { t(": "), i(1, "type"), t(" = "), i(2, "value") },
      { t(" = "), i(1, "value") },
    }), t(";"),
  }),

  s("let", {
    t("let "), i(1, "name"), c(2, {
      { t(": "), i(1, "type"), t(" = "), i(2, "value") },
      { t(" = "), i(1, "value") },
    }), t(";"),
  }),

  -- Control structures
  s("if", {
    t("if ("), i(1, "condition"), t(") {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("ife", {
    t("if ("), i(1, "condition"), t(") {"),
    t({"", "\t"}), i(2),
    t({"", "} else {"}),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("for", {
    t("for ("), i(1, "let i = 0; i < array.length; i++"), t(") {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("foro", {
    t("for (const "), i(1, "item"), t(" of "), i(2, "array"), t(") {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("forin", {
    t("for (const "), i(1, "key"), t(" in "), i(2, "object"), t(") {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("while", {
    t("while ("), i(1, "condition"), t(") {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("switch", {
    t("switch ("), i(1, "expression"), t(") {"),
    t({"", "\tcase "}), i(2, "value"), t(":"),
    t({"", "\t\t"}), i(3),
    t({"", "\t\tbreak;"}),
    t({"", "\tdefault:"}),
    t({"", "\t\t"}), i(0),
    t({"", "}"}),
  }),

  -- Try-catch
  s("try", {
    t("try {"),
    t({"", "\t"}), i(1),
    t({"", "} catch ("), i(2, "error"), t(") {"),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  s("tryf", {
    t("try {"),
    t({"", "\t"}), i(1),
    t({"", "} catch ("), i(2, "error"), t(") {"),
    t({"", "\t"}), i(3),
    t({"", "} finally {"}),
    t({"", "\t"}), i(0),
    t({"", "}"}),
  }),

  -- Async/await
  s("await", {
    t("await "), i(0),
  }),

  s("promise", {
    t("new Promise<"), i(1, "type"), t(">((resolve, reject) => {"),
    t({"", "\t"}), i(0),
    t({"", "});"}),
  }),

  -- Import/export
  s("imp", {
    t("import "), c(1, {
      { i(1, "module"), t(" from '"), i(2, "path"), t("';") },
      { t("{ "), i(1, "export"), t(" } from '"), i(2, "path"), t("';") },
      { t("* as "), i(1, "name"), t(" from '"), i(2, "path"), t("';") },
    }),
  }),

  s("exp", {
    t("export "), c(1, {
      { t("default "), i(1) },
      { t("const "), i(1, "name"), t(" = "), i(2) },
      { t("{ "), i(1), t(" }") },
    }), t(";"),
  }),

  -- Array methods
  s("map", {
    t(".map(("), i(1, "item"), c(2, {
      t(""),
      { t(", "), i(1, "index") },
    }), t(") => "), i(0), t(")"),
  }),

  s("filter", {
    t(".filter(("), i(1, "item"), c(2, {
      t(""),
      { t(", "), i(1, "index") },
    }), t(") => "), i(0), t(")"),
  }),

  s("reduce", {
    t(".reduce(("), i(1, "acc"), t(", "), i(2, "item"), c(3, {
      t(""),
      { t(", "), i(1, "index") },
    }), t(") => "), i(0), t(", "), i(4, "initialValue"), t(")"),
  }),

  s("find", {
    t(".find(("), i(1, "item"), c(2, {
      t(""),
      { t(", "), i(1, "index") },
    }), t(") => "), i(0), t(")"),
  }),

  -- Object/destructuring
  s("dest", {
    t("const { "), i(1), t(" } = "), i(0),
  }),

  s("desta", {
    t("const ["), i(1), t("] = "), i(0),
  }),

  -- Console and debugging
  s("log", {
    t("console.log("), i(0), t(");"),
  }),

  s("warn", {
    t("console.warn("), i(0), t(");"),
  }),

  s("error", {
    t("console.error("), i(0), t(");"),
  }),

  -- Generic utilities
  s("todo", {
    t("// TODO: "), i(0),
  }),

  s("fixme", {
    t("// FIXME: "), i(0),
  }),

  s("note", {
    t("// NOTE: "), i(0),
  }),
}
