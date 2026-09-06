//
//  JLPluginDevice.swift
//  JLPluginDevice
//
//  Created by Camilo on 05-09-26.
//

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
