# Antora Docs Contributors

Example usage for docs creation.

## Commands

A Taskfile.yml can be used to build the docs.
These are the same so you can choose which is best for your use case.

**Taskfile.yml**

- `task install`: Builds the Dockerfile.
- `task build`: Compiles Antora Docs.
- `task sh`: Opens the Container.
- `task server`: Starts a new server for the HTML version (requires Python 3).

## Directories

- antora/: Contains the main antora docs configuration files and documentation.
- docs/: The build command will generate a docs directory so it can be used in Github pages.

This separation is important so the developer can use this template and add it
to an ongoing project easily or start a new one using the file structure as a base.

## Usage

1. Change `CONTAINER_LABEL=local/antora:example-docs` (in Taskfile) to a unique name for your docs.
2. Install the Container: `task install`.
3. (In another terminal) Open a localhost: `task server`.
4. Open Container: `task sh`.
5. Change settings in `antora-playbook.yml`
6. Add modules in `antora.yml`
7. Run Antora: `antora antora-playbook.yml --stacktrace`.
8. See results in `localhost:8000`

If something does not work or does not render well, remember that *antora* needs a git repository.

- `git init`: Creates a new git repo.
- `git commit -am 'update docs'`: Creates a new commit, after this try to render the docs again.

> **NOTE**
>
> If you want to have `task` you must have installed it https://taskfile.dev/

## How to add content

Inside `modules` you can add a new module that will contain pages, examples and images.

Example let's create a new *users* module.

```text
modules/
  users/
   nav.adoc
   pages/
      users.adoc
      roles.adoc
    images/
      image1.png
    examples/
      example.py
  ROOT/
    ...
```

- pages: Will contain the adoc pages for the content.
- images: Will contain images used inside the pages with `image::image1.png[]`.
- examples: Will contain code examples and other resources for the content.

### Contents

Inside `nav.adoc` you must put the pages.

**nav.adoc**

```asciidoc
.Users
* xref:users.adoc[]
* xref:roles.adoc[]
```

Inside `examples` you can store code.

**example.exs**

```elixir
include::modules/ROOT/examples/example.exs[]
```

## antora.yml

New modules must be added to antora.yml file in the nav property
including the nav.adoc.

```yml
nav:
  - modules/ROOT/nav.adoc
```

## Example Syntax
See @example.adoc for syntax reference
