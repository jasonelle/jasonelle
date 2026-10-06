//
//  JLKernel/Events.swift
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
    Logger(from: Events.self).debug("Sending \(contentViewOnAppear) event to plugins")
    for (_, plugin) in plugins {
      plugin.handle_event(Events.contentViewOnAppear.rawValue) { _ in }
    }
  }
}
