---
description: Update an ADR status to Deprecated and record the previous status.
---

Update the status of the ADR named `$ARGUMENTS` to `Deprecated` and record the
previous status in a new `=== History` section after `== Status`.

## Steps

1. `$ARGUMENTS` is the ADR name (slug); locate the file via
   `glob antora/modules/decisions/pages/*<name>.adoc` (e.g. `adopt-adr-documents`
   → `0000000-adopt-adr-documents.adoc`). If no file matches, report it and
   stop.
2. Get today's date via `date +%Y-%m-%d` and the current git user via
   `git config user.name` to use as `@<git-user>`.
3. Read the `== Status` section. If the current status is already `Deprecated`,
   report it and leave the file unchanged.
4. Replace the status list item with `- Deprecated (<today>) by: @<git-user>`.
5. Move the old status line into a `=== History` subsection placed immediately
   after `== Status`:

   ```adoc
   == Status

   - Deprecated (<YYYY-MM-DD>) by: @<git-user>

   === History

   - <old-status> (<old-date>) by: @<old-user>
   ```

   If a `=== History` section already exists, append the old status as a new
   list item below it instead of duplicating the heading. Order dates DESC.

## Restrictions

- Only modify the targeted ADR file. Do not touch `nav.adoc` and do not commit
  or push.

## Output

- Report the file changed, the old vs. new status lines, and the added History
  entry.
- Recommend re-building antora docs with `task docs`.
