//
//  JLPluginCookies/Plugin.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-07
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
import JLKernel
import Security

public final class Plugin: JLKernel.Plugin {
  override public static var name: String { "cookies" }

  private static let service = "com.jasonelle.plugins.cookies"
  private static let account = "cookie"

  // Native handler called when JS invokes window.jasonelle.plugins.cookies.save(value)
  // or window.jasonelle.plugins.cookies.restore(). The action is read from args.
  public override func handle_call(callbackId: String, args: [String: Any]? = [:], respond: @escaping (String) -> Void) {
    switch args?["action"] as? String {
    case "save":
      guard let value = args?["value"] as? String else {
        self.reject(args: ["error": "Missing 'value'"], callbackId: callbackId, status: "error", respond: respond)
        return
      }
      self.save(value)
      self.resolve(args: ["status": "ok"], callbackId: callbackId, respond: respond)

    case "restore":
      self.resolve(args: ["value": self.restore() ?? ""], callbackId: callbackId, respond: respond)

    default:
      self.reject(args: ["error": "Unknown action"], callbackId: callbackId, status: "error", respond: respond)
    }
  }

  /// Stores the cookie string in the iOS keychain under the "cookie" account.
  private func save(_ value: String) {
    guard let data = value.data(using: .utf8) else { return }
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: Plugin.service,
      kSecAttrAccount as String: Plugin.account,
      kSecValueData as String: data,
    ]
    SecItemDelete(query as CFDictionary)
    let status = SecItemAdd(query as CFDictionary, nil)
    if status != errSecSuccess {
      self.logger.notice("Keychain save failed with status \(status)")
    }
  }

  /// Reads the stored cookie string from the iOS keychain.
  private func restore() -> String? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrService as String: Plugin.service,
      kSecAttrAccount as String: Plugin.account,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne,
    ]
    var result: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &result)
    guard status == errSecSuccess, let data = result as? Data else { return nil }
    return String(data: data, encoding: .utf8)
  }
}
