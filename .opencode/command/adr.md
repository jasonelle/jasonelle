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

## Steps

1. Determine the ADR number:
   - List `antora/modules/decisions/pages/*.adoc` and extract the leading
     7-digit prefix of each file matching `^([0-9]{7})-.*\.adoc$`.
   - Take the maximum number, increment it by 1, and zero-pad it to 7 digits.
   - If there are no existing ADRs, start at `0000000`.
2. Create `antora/modules/decisions/pages/<number>-<name>.adoc` using the MADR
   template below. Ask the user for the decision details and fill in the
   placeholders.
3. Add `* xref:<number>-<name>.adoc[]` to `antora/modules/decisions/nav.adoc`
   below the `.Arquitecture Decision Records` heading. If the entry already
   exists, do not duplicate it.

## Template

```adoc
= <Title>

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

## Output

- Report the created file (with its number) and the exact line added to
`nav.adoc`.
- Recommend re-building antora docs with `task docs`
