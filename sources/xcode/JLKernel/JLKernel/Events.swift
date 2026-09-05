//
//  Events.swift
//  Application
//
//  Created by Camilo on 05-09-26.
//

import Foundation

// Native events that plugins can listen to via handle_event(name:).
// The raw value is the event name sent to the native handler.
public enum Events: String {
  case contentViewOnAppear = "ContentView.onAppear"

  /// Plugins registered by the app. Defaults to empty until set.
  public static var plugins: [String: Plugin] = [:]

  /// Registers the plugins the app will receive events with.
  public static func register(plugins: [String: Plugin]) {
    Events.plugins = plugins
  }

  /// Sends the `ContentView.onAppear` event to every registered plugin.
  ///
  /// Plugins receive the event through `handle_event(name:args:respond:)`
  /// with the event name as raw value and no arguments.
  /// The app registers plugins in `Main.init()` via `register(plugins:)`.
  public static func sendOnAppear() {
    for (_, plugin) in plugins {
      plugin.handle_event(name: Events.contentViewOnAppear.rawValue, args: nil) { _ in }
    }
  }
}
