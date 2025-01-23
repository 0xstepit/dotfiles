local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local c = ls.choice_node
local i = ls.insert_node
local f = ls.function_node

ls.config.setup({ store_selection_keys = "<Tab>" })

local filename = function()
  return vim.fn.fnamemodify(vim.fn.expand("%"), ":t:r")
end

local slugify = function()
  local title = vim.fn.fnamemodify(vim.fn.expand("%"), ":t:r")
  return title:lower():gsub("[%p%c]+", ""):gsub("%s+", "-")
end

local current_date = function()
  return { os.date("%Y-%m-%d") }
end

local get_selection = function(_, snip)
  return snip.env.TM_SELECTED_TEXT[1] or {}
end

return {
  s({ trig = "``", desc = "Insert codeblock" }, {
    t({ "```" }),
    c(1, { t("go"), t("sh"), t("rust"), i(nil, "lang") }),
    t({ "", "" }), -- is there a better way to have a new line?
    i(2, "code"),
    t({ "", "```" }),
  }),
  s({ trig = "frontmatter", desc = " Generate the frontmatter and title" }, {
    t("---"),
    t({ "", "author: Stefano Francesco Pitton" }),
    t({ "", "title: " }),
    f(filename, {}),
    t({ "", "slug: " }),
    f(slugify, {}),
    t({ "", "aliases: [" }),
    i(1, ""),
    t("]"),
    t({ "", "tags: [" }),
    i(2, ""),
    t("]"),
    t({ "", "related: [" }),
    i(3, ""),
    t("]"),
    t({ "", "creation: " }),
    f(current_date, {}),
    t({ "", "modified: " }),
    f(current_date, {}),
    t({ "", "to-publish: false" }),
    t({ "", "---" }),
    t({ "", "", "# " }),
    f(filename, {}),
    t({ "", "", "" }),
  }),
  s({ trig = "link", desc = "Add md link [text](link)" }, {
    t("["),
    i(1, "text"),
    t("]("),
    f(get_selection, {}),
    t(")"),
  }),
  s({ trig = "title", desc = "Insert filename as H1" }, {
    t("# "),
    f(filename, {}),
  }),
}
