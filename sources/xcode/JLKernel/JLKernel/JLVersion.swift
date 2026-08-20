//
//  JLVersion.swift
//  JLKernel
//
//  Created by Camilo on 19-08-26.
//

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
