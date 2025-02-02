local M = {}

function M.move_note_command(destination)
  local current_file = {
    path = vim.fn.fnamemodify(vim.fn.expand("%"), ":p"),
    name = vim.fn.fnamemodify(vim.fn.expand("%"), ":t"),
    extension = vim.fn.fnamemodify(vim.fn.expand("%"), ":e"),
  }

  if current_file.extension ~= "md" then
    vim.notify("Aborting because current file is not a note")
    return { error = true, cmd = "" }
  end

  local notes_dir = os.getenv("NOTES")
  if not notes_dir or notes_dir == "" then
    vim.notify("Aborting because $NOTES env variable is empty")
    return { error = true, cmd = "" }
  end

  local destination_dir = table.concat({ notes_dir, "main", destination }, "/")
  if vim.fn.isdirectory(destination_dir) == 0 then
    vim.notify("Destination directory does not exist")
    return { error = true, cmd = "" }
  end

  local note_path = table.concat({ destination_dir, current_file.name }, "/")

  local success = vim.fn.rename(current_file.path, note_path)
  if success ~= 0 then
    vim.notify("Error while renaming current file name")
    return { error = true, cmd = "" }
  end

  local cmd = ":e " .. note_path
  vim.notify("Successfully moved note to " .. destination)
  return { error = false, cmd = cmd }
end

function M.new_note(title)
  -- Get env vars required for the creation of a new note.
  local notes_dir = os.getenv("NOTES")
  if not notes_dir or notes_dir == "" then
    return { error = true, message = "$NOTES environment variable is not set" }
  end

  local inbox = os.getenv("INBOX")
  if not inbox or inbox == "" then
    return { error = true, message = "$INBOX environment variable is not set" }
  end

  local note_title = title:gsub("^%l", string.upper)
  local note_title_md = note_title .. ".md"

  local inbox_dir = table.concat({ notes_dir, "main", inbox }, "/")
  local note_path = table.concat({ inbox_dir, note_title_md }, "/")

  if vim.fn.isdirectory(inbox_dir) == 0 then
    return {
      error = true,
      message = string.format("Inbox directory does not exist: %s", inbox_dir),
    }
  end

  if vim.fn.filereadable(note_path) == 1 then
    return { error = true, message = string.format("Note already exists: %s", note_path) }
  end

  local file = io.open(note_path, "w")
  if not file then
    return { error = true, message = string.format("Failed to create file: %s", note_path) }
  end

  local date = os.date("%Y-%m-%d")
  local frontmatter = {
    "---",
    "author: Stefano Francesco Pitton",
    string.format("title: '%s'", note_title),
    string.format("slug: '%s'", note_title:lower():gsub("%s+", "-")),
    "tags: []",
    "related: []",
    string.format("created: %s", date),
    string.format("modified: %s", date),
    "to-publish: false",
    "---",
    "",
    string.format("# %s", note_title),
    "",
  }

  file:write(table.concat(frontmatter, "\n"))
  file:close()

  vim.cmd(string.format("edit %s", note_path))
  return {
    error = false,
    message = string.format("Successfully created note: %s", note_title),
  }
end

return M
