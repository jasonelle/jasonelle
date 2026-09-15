---
description: Append a license template as a comment to the first lines of a file or directory.
---

Append the license template to the file `$1` or directory `$2`. The license is
added as a comment in the same programming language as each file, at the
beginning (first lines) of the code. If `$1` or `$2` is missing, ask the user
for it.

For a directory, apply it to every code source file recursively, but ask for confirmation
if the flag `-y` or word `force` or `all` is not present. Valid extensions:
`.go`, `.js`, `.m`, `.h`, `.c`, `.css`, `.html`, `.swift`, `.kt`, `.yml`,
`.yaml`. Ask for confirmation before modifying files.

Example: `/append-license /tools all`

## Steps

1. If `$2` is a directory, list the source files inside it recursively.
2. For each file, determine the comment syntax from its extension (`//` for
   C-like/Swift/Kotlin, `#` for YAML/`*.yml`/shell/Python/Elixir,
   `<!-- -->` for HTML).
3. Read the first lines of the file. If a license header is already present,
   replace it with the template below, filling the placeholders with actual
   information. Otherwise insert the license as a comment block at the start
   of the file, followed by a blank line.
4. Preserve the original file encoding and end-of-line style.

## Template

Fill the template

- `{{directory}}`: current directory where the file is located or the package context if available.
- `{{filename.extension}}`: basename of the file to be modified with the license.
- `{{date}}`: creation date of the file (birth time) in ISO 8601 format
  (`YYYY-MM-DD`). On macOS read it with `stat -f '%SB' -t '%Y-%m-%d' <file>`.
  A directory may yield files with different dates, so compute it per file.

```c
//  {{directory}}/{{filename.extension}}
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on {{date}}
//  Made with love in Chile.
//
//  Copyright (c) Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels at https://jasonelle.com.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
//
```

## Output

- Report the list of files modified.