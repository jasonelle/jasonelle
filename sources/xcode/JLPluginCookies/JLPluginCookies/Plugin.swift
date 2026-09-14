//
//  JLPluginCookies.swift
//  JLPluginCookies
//
//  Created by Camilo on 07-09-26.
//

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