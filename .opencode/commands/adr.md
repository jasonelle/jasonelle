---
description: Create a new Architecture Decision Record (MADR) page.
---

Create a new Architecture Decision Record (ADR) following [MADR 4.0.0](https://adr.github.io/madr/) and add it to the decisions navigation.

The filenames are following the pattern `NNNNNNN-title-with-dashes.adoc` where:

- NNNNNNN is a consecutive number and we assume that there won’t be more than 1000000 ADRs in one repository.
- The title is stored using dashes and lowercase, because adr-tools also does that.
- The suffix is `.adoc`, because it is a Asciidoc file.

## Arguments

`$ARGUMENTS` is the ADR name; use it as the file slug (e.g. `/adr use-antora`
creates `0000001-use-antora.adoc`). If no name is given, ask the user for one.

## Status Change

### Status Change Steps

1. `$1` is the ADR name (slug); locate the file via
   `glob antora/modules/decisions/pages/*<name>.adoc` (e.g. `adopt-adr-documents`
   → `0000000-adopt-adr-documents.adoc`). If no file matches, report it and
   stop. `$2` is the new status (accept, deprecate, supersed).
2. Get today's date via `date +%Y-%m-%d` and the current git user via
   `git config user.name` to use as `@<git-user>`.
3. Read the `== Status` section. If the current status is already the solicited status eg. `Accepted`, `Deprecated`, `Superseded`,
   report it and leave the file unchanged.
4. Replace the status list item with `- Accepted (<today>) by: @<git-user>`. Only one status is allowed at the same time inside `== Status`.
5. Move the old status line into a `=== History` subsection placed immediately
   after `== Status`:

```adoc
== Status

- Superseded by <xxx> (<YYYY-MM-DD>) by: @<git-user>

=== History

- <old-status> (<old-date>) by: @<old-user>
- Accepted (<YYYY-MM-DD>) by: @<git-user>
- Deprecated (<YYYY-MM-DD>) by: @<git-user>
```

If a `=== History` section already exists, append the old status as a new
list item below it instead of duplicating the heading. Order dates DESC.

### Status Change Restrictions

- Only modify the targeted ADR file. Do not touch `nav.adoc` and do not commit
  or push.

### Status Change Output

- Report the file changed, the old vs. new status lines, and the added History
  entry.
- Recommend re-building antora docs with `task docs`.

### Status: Accept

Update the status of the ADR named `$1` to `Accepted` and record the
previous status in a new `=== History` section after `== Status` 
if the param `$2` is "accepted", "accept", "ok", or any word related to accept.

### Status: Deprecated

Update the status of the ADR named `$1` to `Deprecated` and record the
previous status in a new `=== History` section after `== Status`.
if the param `$2` is "deprecate", "deprecated", "obsolete", or any word related to deprecation.

### Status: Supersed

Update the status of the ADR named `$1` to `Superseded by <xxx>` and
record the previous status in a new `=== History` section after `== Status`.
if the param `$2` is "supersed", "superseded", or any word related to supersed.

## New ADR Steps

1. Determine the ADR number:
   - List `antora/modules/decisions/pages/*.adoc` and extract the leading
     7-digit prefix of each file matching `^([0-9]{7})-.*\.adoc$`.
   - Take the maximum number, increment it by 1, and zero-pad it to 7 digits.
   - If there are no existing ADRs, start at `0000000`.
2. Create `antora/modules/decisions/pages/<number>-<name>.adoc` using the MADR
   template below, with `<number>` as the `id`. Ask the user for the decision
   details and fill in the placeholders.
3. Add `* xref:<number>-<name>.adoc[]` to `antora/modules/decisions/nav.adoc`
   below the `.Arquitecture Decision Records` heading. If the entry already
   exists, do not duplicate it.

### Template

```adoc
= <Title>

- id: <number>

== Status

- <Accepted|Proposed|Deprecated|Superseded by [xxx]> (<YYYY-MM-DD>) by: @<git-user>

== Context and Problem Statement

<Describe the context and problem statement, e.g., in two or three sentences.
You may want to articulate the problem in form of a question.>

== Considered Options

* <Option 1>
* <Option 2>
* <Option 3>

== Decision Outcome

Chosen option: "<Option 1>", because <justification>. Positive consequences:
<positive consequences>. Negative consequences: <negative consequences>.

<Option 1> is <best, because ... | not the best, because ...>. If <Option 2>
was chosen, <negative consequences>. If <Option 3> was chosen, <negative
consequences>.
```

Follow https://github.com/adr/madr/blob/develop/template/adr-template-minimal.md
for the minimal structure if the decision is simple.

Set the status date to today's date via `date +%Y-%m-%d`.

Get the current git user via `git config user.name` and use it as `@<git-user>`
in the status line.

## New ADR Output

- Report the created file (with its number) and the exact line added to
`nav.adoc`.
- Recommend re-building antora docs with `task docs`

## When to use an ADR

All three of these must be true:

1. **Hard to reverse**: the cost of changing your mind later is meaningful
2. **Surprising without context**: a future reader will look at the code and wonder "why on earth did they do it this way?"
3. **The result of a real trade-off**: there were genuine alternatives and you picked one for specific reasons

If a decision is easy to reverse, skip it: you'll just reverse it. If it's not surprising, nobody will wonder why. If there was no real alternative, there's nothing to record beyond "we did the obvious thing."

## What qualifies as ADR

- **Architectural shape.** "We're using a monorepo." "The write model is event-sourced, the read model is projected into Postgres."
- **Integration patterns between contexts.** "Ordering and Billing communicate via domain events, not synchronous HTTP."
- **Technology choices that carry lock-in.** Database, message bus, auth provider, deployment target. Not every library: just the ones that would take a quarter to swap out.
- **Boundary and scope decisions.** "Customer data is owned by the Customer context; other contexts reference it by ID only." The explicit no-s are as valuable as the yes-s.
- **Deliberate deviations from the obvious path.** "We're using manual SQL instead of an ORM because X." Anything where a reasonable reader would assume the opposite. These stop the next engineer from "fixing" something that was deliberate.
- **Constraints not visible in the code.** "We can't use AWS because of compliance requirements." "Response times must be under 200ms because of the partner API contract."
- **Rejected alternatives when the rejection is non-obvious.** If you considered GraphQL and picked REST for subtle reasons, record it; otherwise someone will suggest GraphQL again in six months.
