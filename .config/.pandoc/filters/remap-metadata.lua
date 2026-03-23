-- Frontmatter used in my knowledge base:
-- author: stepit
-- title: ''
-- slug: ''
-- created: YYYY-MM-DD
-- modified: YYYY-MM-DD
-- summary: ''
-- category: ''
-- tags: []
-- related: []
-- to-publish: bool

--- Meta converts the metadata from the format used in the knowledge base
--- into Pandoc expected metada variables.
--- Ref: https://pandoc.org/MANUAL.html#metadata-variables
function Meta(m)
	if m.created then
		m.date = m.created
	end

	if m.tags then
		m.keywords = m.tags
	end

	m["link-citations"] = true -- create a link from citation to reference

	m.colorlinks = true
	m.linkcolor = "blue"
	m.urlcolor = "blue"
	return m
end
