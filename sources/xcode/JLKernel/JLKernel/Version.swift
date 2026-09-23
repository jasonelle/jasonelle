//
//  JLKernel/Version.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-08-26
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

/// The framework's version information, read from the bundled VERSION resource.
public struct Version {
  private static let defaultVersion = "4.x.x"
  public static var version: String?

  /// The semantic version string (e.g. "4.0.0").
  ///
  /// Reads from the ``VERSION`` resource file bundled with JLKernel.
  /// Returns `"4.x.x"` if the file is missing or unreadable.
  ///
  /// - Returns: A trimmed semantic version string.
  public static func semantic() -> String {
    if Version.version?.isEmpty == false { return Version.version! }

    guard let url = Bundle(for: Kernel.self).url(forResource: "VERSION", withExtension: nil),
      let data = try? Data(contentsOf: url),
      let version = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines)
    else {
      return defaultVersion
    }
    Version.version = version
    return version
  }
}
