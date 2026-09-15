---
description: Fix license header in code files
---

Add license comment header to all source files with the following
extensions:

  - *.swift
  - *.c
  - *.h
  - *.kt
  - *.js
  - *.m
  - *.yml

If the file has a license header, replace it filling the placeholders with actual information.

Check inside `sources/xcode` and `sources/android` directories.

Check $ARGUMENTS for any additional context or restrictions

Use the following license template. Addapt it to the single comment of the programming language or file:

```text
//
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
```
