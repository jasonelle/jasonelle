//
//  JLKernel/Configuration.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-06
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

import Foundation

public struct AppConfiguration: Decodable {
    let url: URL // The url that will load as the main url for the app
    let inspectable: Bool? // Makes the webview inspectable in Safari web console
    let allowed: [String]? // List of hosts allowed to load in the webview. Empty or nil = all URLs load in webview. Non-empty = only listed hosts load in webview, others open SFSafariViewController. The app URL (url) is always allowed.
    // Add any other configuration properties you need here

  public init(url: URL, inspectable: Bool = true, allowed: [String] = []) {
      self.url = url
      self.inspectable = inspectable
      self.allowed = allowed
    }
}

enum ConfigurationError: Error {
    case fileNotFound
    case decodingError(Error)
}

class ConfigurationLoader {

    private static let logger: Logger = Logger(from: type(of: ConfigurationLoader.self))

    static func load(from url: URL? = Bundle.main.url(forResource: "config", withExtension: "jsonc")) throws -> AppConfiguration {
        // Look for config.jsonc in the main app bundle by default
        guard let url = url else {
            throw ConfigurationError.fileNotFound
        }
        let data = try Data(contentsOf: url)
        let decoded = try decode(data: data)
        logger.info("Successfully loaded configuration")
        logger.debug("\(decoded)")
        return decoded
    }

    // Extracted for unit testing
    static func decode(data: Data) throws -> AppConfiguration {
        let decoder = JSONDecoder()
        let cleanData = stripJSONCComments(data)
        if #available(iOS 15.0, macOS 12.0, *) {
            decoder.allowsJSON5 = true
        }

        do {
            return try decoder.decode(AppConfiguration.self, from: cleanData)
        } catch {
            throw ConfigurationError.decodingError(error)
        }
    }

    // ponytail: handles // and /* */ outside strings; good enough for config files
    private static func stripJSONCComments(_ data: Data) -> Data {
        guard let str = String(data: data, encoding: .utf8) else { return data }
        var result = ""
        var i = str.startIndex
        var inString = false
        var escaped = false

        while i < str.endIndex {
            let c = str[i]

            if escaped {
                escaped = false
                result.append(c)
                i = str.index(after: i)
                continue
            }

            if c == "\\" && inString {
                escaped = true
                result.append(c)
                i = str.index(after: i)
                continue
            }

            if c == "\"" {
                inString.toggle()
                result.append(c)
                i = str.index(after: i)
                continue
            }

            if !inString && c == "/" {
                let next = str.index(after: i)
                if next < str.endIndex {
                    let nc = str[next]
                    if nc == "/" {
                        if let newlineRange = str[i...].range(of: "\n") {
                            i = newlineRange.upperBound
                        } else {
                            i = str.endIndex
                        }
                        continue
                    } else if nc == "*" {
                        if let end = str.range(of: "*/", range: str.index(i, offsetBy: 2)..<str.endIndex) {
                            i = end.upperBound
                        } else {
                            i = str.endIndex
                        }
                        continue
                    }
                }
            }

            result.append(c)
            i = str.index(after: i)
        }

        return result.data(using: .utf8) ?? data
    }
}
