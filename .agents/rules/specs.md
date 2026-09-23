---
description: All the superpowers/specs must be writen inside antora/modules/specs
---

When writing specs with `superpowers`. Example
`docs/superpowers/specs/2026-09-20-link-copy-artifacts-design.md` take the
contents, transform them to asciidoc and write the output to
`antora/modules/specs/pages/`. Example
`antora/modules/specs/pages/2026-09-20-link-copy-artifacts-design.adoc`.

- Start the page with a title: `= <Page Title>`.
- Add the page to `antora/modules/specs/nav.adoc`:

```adoc
.Specs
* xref:2026-09-20-link-copy-artifacts-design.adoc[]
```

- Register the specs nav in `antora/antora.yml` under `nav:`
  (`- modules/specs/nav.adoc`). A nav that is not listed there is never
  rendered.

- All the future updates to the spec must be written to the corresponding antora page.
- All the original `superpowers/specs/*.md` must be deleted once the antora page is created.
