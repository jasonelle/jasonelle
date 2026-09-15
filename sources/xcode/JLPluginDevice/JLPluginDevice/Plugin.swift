//
//  JLPluginDevice/Plugin.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-05
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
#if os(iOS)
import UIKit
#endif

public final class Plugin: JLKernel.Plugin {
  override public static var name: String { "device" }

  public override func handle_call(callbackId: String, args: [String: Any]? = [:], respond: @escaping (String) -> Void) {
    
    self.logger.info("Handling device info request")

    let os = deviceOS()
    let vendor = "apple"
    let osVersion = ProcessInfo.processInfo.operatingSystemVersion
    let version = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
    let deviceType = self.deviceType()
    let orientation = self.orientation()
    let screenSize = self.screenSize()

    let result : [String : Any] = [
      "os": ["name": os, "version": version],
      "vendor": vendor,
      "type": deviceType,
      "orientation": orientation,
      "screen": ["width": screenSize.width, "height": screenSize.height]
    ]
        
    self.resolve(args: result, callbackId: callbackId, respond: respond)
  }

  private func deviceOS() -> String {
    #if os(iOS)
    return "ios"
    #elseif os(macOS)
    return "macos"
    #elseif os(tvOS)
    return "tvos"
    #elseif os(watchOS)
    return "watchos"
    #else
    return "unknown"
    #endif
  }

  private func deviceType() -> String {
    #if os(iOS)
    let idiom = UIDevice.current.userInterfaceIdiom
    switch idiom {
    case .pad: return "ipad"
    default: return "iphone"
    }
    #elseif os(macOS)
    return "macos"
    #else
    return "unknown"
    #endif
  }

  private func orientation() -> String {
    #if os(iOS)
    let raw: UIDeviceOrientation
    if #available(iOS 16.0, *) {
      let scene = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first { $0.activationState == .foregroundActive }
      raw = scene.flatMap { UIDeviceOrientation(rawValue: $0.effectiveGeometry.interfaceOrientation.rawValue) } ?? UIDevice.current.orientation
    } else {
      raw = UIDevice.current.orientation
    }
    switch raw {
      case .portrait: return "portrait"
      case .portraitUpsideDown: return "portraitUpsideDown"
      case .landscapeLeft: return "landscapeLeft"
      case .landscapeRight: return "landscapeRight"
      case .faceUp: return "faceUp"
      case .faceDown: return "faceDown"
      default: return "unknown"
    }
    #else
    return "unknown"
    #endif
  }

  private func screenSize() -> (width: CGFloat, height: CGFloat) {
    #if os(iOS)
    let bounds: CGRect
    if #available(iOS 26.0, *) {
      let screen = UIApplication.shared.connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .filter { $0.activationState == .foregroundActive }
        .first?.keyWindow?.screen
      bounds = screen?.bounds ?? .zero
    } else {
      bounds = UIScreen.main.bounds
    }
    return (bounds.width, bounds.height)
    #elseif os(macOS)
    let frame = NSScreen.main?.frame ?? .zero
    return (frame.width, frame.height)
    #else
    return (0, 0)
    #endif
  }
}
