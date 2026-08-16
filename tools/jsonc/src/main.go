//  main.go
//  tools/jsonc
//
//  Created by clsource on 2026-08-16
//
//  Copyright (c) Jasonelle
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
//

package main

import (
	"encoding/json"
	"errors"
	"flag"
	"fmt"
	"os"
)

func main() {
	if err := run(os.Args[1:]); err != nil {
		fatal(err)
	}
}

func run(args []string) error {
	fs := flag.NewFlagSet("jsonc", flag.ContinueOnError)
	output := fs.String("output", "", "output JSONC file path")
	if err := fs.Parse(args); err != nil {
		return err
	}

	if *output == "" {
		return errors.New("-output is required")
	}
	inputs := fs.Args()
	if len(inputs) == 0 {
		return errors.New("at least one input file is required")
	}

	merged := map[string]any{}
	for _, path := range inputs {
		data, err := os.ReadFile(path)
		if err != nil {
			return err
		}
		var obj map[string]any
		if err := json.Unmarshal(stripJSONC(data), &obj); err != nil {
			return fmt.Errorf("%s: %w", path, err)
		}
		merge(merged, obj)
	}

	out, err := json.MarshalIndent(merged, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(*output, append(out, '\n'), 0644)
}

func merge(dst, src map[string]any) {
	for k, v := range src {
		if sv, ok := v.(map[string]any); ok {
			if dv, ok := dst[k].(map[string]any); ok {
				merge(dv, sv)
				continue
			}
		}
		dst[k] = v
	}
}

func stripJSONC(data []byte) []byte {
	var out []byte
	inStr := false
	for i := 0; i < len(data); i++ {
		c := data[i]
		if inStr {
			out = append(out, c)
			if c == '\\' {
				i++
				if i < len(data) {
					out = append(out, data[i])
				}
			} else if c == '"' {
				inStr = false
			}
			continue
		}
		switch c {
		case '"':
			inStr = true
			out = append(out, c)
		case '/':
			if i+1 < len(data) && data[i+1] == '/' {
				for i < len(data) && data[i] != '\n' {
					i++
				}
			} else if i+1 < len(data) && data[i+1] == '*' {
				i += 2
				for i+1 < len(data) && !(data[i] == '*' && data[i+1] == '/') {
					i++
				}
				i++
			} else {
				out = append(out, c)
			}
		case ',':
			j := i + 1
			for j < len(data) && (data[j] == ' ' || data[j] == '\t' || data[j] == '\n' || data[j] == '\r') {
				j++
			}
			if j < len(data) && (data[j] == '}' || data[j] == ']') {
				continue
			}
			out = append(out, c)
		default:
			out = append(out, c)
		}
	}
	return out
}

func fatal(err error) {
	fmt.Fprintln(os.Stderr, err)
	os.Exit(1)
}
