//
//  JLPluginOpenTelemetry/Plugin.swift
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
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the
//  Affero GNU General Public License as published by the Free Software Foundation, either
//  version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
//  without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
//  PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle.
//  If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.
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
import OpenTelemetryApi

public final class Plugin: JLKernel.Plugin {
  override public static var name: String { "opentelemetry" }

  public override func handle_call(callbackId: String, args: [String: Any]? = [:], respond: @escaping (String) -> Void) {
    self.logger.info("Handling opentelemetry metrics request")

    guard let action = args?["action"] as? String else {
      self.reject(args: ["error": "No action provided"], callbackId: callbackId, status: "error", respond: respond)
      return
    }

    switch action {
    case "counter.add":
      self.handleCounterAdd(args: args)
      self.resolve(args: ["success": true], callbackId: callbackId, respond: respond)
    case "histogram.record":
      self.handleHistogramRecord(args: args)
      self.resolve(args: ["success": true], callbackId: callbackId, respond: respond)
    default:
      self.reject(args: ["error": "Unknown action \(action)"], callbackId: callbackId, status: "error", respond: respond)
    }
  }

  /// Records `value` on a long counter. Values arrive from JavaScript as `NSNumber`,
  /// so they are coerced here; a float is truncated to a whole number, matching Android.
  private func handleCounterAdd(args: [String: Any]?) {
    guard let name = args?["name"] as? String,
          let value = (args?["value"] as? NSNumber)?.intValue else {
      return
    }

    let meterName = args?["meterName"] as? String ?? "jasonelle.app.meter"
    let meter = OpenTelemetry.instance.meterProvider.get(name: meterName)
    var counter = meter.counterBuilder(name: name).build()
    counter.add(value: value)
  }

  /// Records `value` on a double histogram.
  private func handleHistogramRecord(args: [String: Any]?) {
    guard let name = args?["name"] as? String,
          let value = (args?["value"] as? NSNumber)?.doubleValue else {
      return
    }

    let meterName = args?["meterName"] as? String ?? "jasonelle.app.meter"
    let meter = OpenTelemetry.instance.meterProvider.get(name: meterName)
    var histogram = meter.histogramBuilder(name: name).build()
    histogram.record(value: value)
  }
}
