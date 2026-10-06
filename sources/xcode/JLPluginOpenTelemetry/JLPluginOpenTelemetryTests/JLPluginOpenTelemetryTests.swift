//
//  JLPluginOpenTelemetryTests/JLPluginOpenTelemetryTests.swift
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
import Testing
import JLKernel
@testable import JLPluginOpenTelemetry

struct JLPluginOpenTelemetryTests {

    @Test func exposesNameAndId() async throws {
      #expect(JLPluginOpenTelemetry.Plugin.name == "opentelemetry")
      #expect(JLPluginOpenTelemetry.Plugin.id == "com.jasonelle.plugins.opentelemetry")
    }

    @Test func handle_call_nullArgs_rejectsWithNoActionProvided() async throws {
      let plugin = JLPluginOpenTelemetry.Plugin()
      var response: String?

      plugin.handle_call(callbackId: "call_1", args: nil) { response = $0 }

      let script = response ?? ""
      #expect(script.hasPrefix("window.jasonelle.result.reject({"))
      #expect(script.contains("\"status\":\"error\""))
      #expect(script.contains("\"callbackId\":\"call_1\""))
      #expect(script.contains("\"error\":\"No action provided\""))
    }

    @Test func handle_call_emptyArgs_rejectsWithNoActionProvided() async throws {
      let plugin = JLPluginOpenTelemetry.Plugin()
      var response: String?

      plugin.handle_call(callbackId: "call_1", args: [:]) { response = $0 }

      let script = response ?? ""
      #expect(script.hasPrefix("window.jasonelle.result.reject({"))
      #expect(script.contains("\"error\":\"No action provided\""))
    }

    @Test func handle_call_counterAdd_resolvesSuccess() async throws {
      let plugin = JLPluginOpenTelemetry.Plugin()
      var response: String?

      plugin.handle_call(
        callbackId: "call_1",
        args: ["action": "counter.add", "name": "button_clicks", "value": 1]
      ) { response = $0 }

      let script = response ?? ""
      #expect(script.hasPrefix("window.jasonelle.result.resolve({"))
      #expect(script.contains("\"status\":\"ok\""))
      #expect(script.contains("\"callbackId\":\"call_1\""))
      #expect(script.contains("\"success\":true"))
    }

    @Test func handle_call_counterAddMissingName_stillResolvesSuccess() async throws {
      let plugin = JLPluginOpenTelemetry.Plugin()
      var response: String?

      plugin.handle_call(
        callbackId: "call_1",
        args: ["action": "counter.add", "value": 1]
      ) { response = $0 }

      #expect((response ?? "").contains("\"success\":true"))
    }

    @Test func handle_call_counterAddNonNumericValue_stillResolvesSuccess() async throws {
      let plugin = JLPluginOpenTelemetry.Plugin()
      var response: String?

      plugin.handle_call(
        callbackId: "call_1",
        args: ["action": "counter.add", "name": "button_clicks", "value": "one"]
      ) { response = $0 }

      #expect((response ?? "").contains("\"success\":true"))
    }

    @Test func handle_call_histogramRecord_resolvesSuccess() async throws {
      let plugin = JLPluginOpenTelemetry.Plugin()
      var response: String?

      plugin.handle_call(
        callbackId: "call_1",
        args: [
          "action": "histogram.record",
          "name": "load_time_ms",
          "value": 124.5,
          "meterName": "jasonelle.app.meter"
        ]
      ) { response = $0 }

      let script = response ?? ""
      #expect(script.hasPrefix("window.jasonelle.result.resolve({"))
      #expect(script.contains("\"status\":\"ok\""))
      #expect(script.contains("\"success\":true"))
    }

    @Test func handle_call_histogramRecordMissingName_stillResolvesSuccess() async throws {
      let plugin = JLPluginOpenTelemetry.Plugin()
      var response: String?

      plugin.handle_call(
        callbackId: "call_1",
        args: ["action": "histogram.record", "value": 124.5]
      ) { response = $0 }

      #expect((response ?? "").contains("\"success\":true"))
    }

    @Test func handle_call_unknownAction_rejectsWithError() async throws {
      let plugin = JLPluginOpenTelemetry.Plugin()
      var response: String?

      plugin.handle_call(callbackId: "call_1", args: ["action": "gauge.record"]) { response = $0 }

      let script = response ?? ""
      #expect(script.hasPrefix("window.jasonelle.result.reject({"))
      #expect(script.contains("\"status\":\"error\""))
      #expect(script.contains("\"error\":\"Unknown action gauge.record\""))
    }

    @Test func eventWithoutHandlerDoesNotRespond() async throws {
      let plugin = JLPluginOpenTelemetry.Plugin()
      var response: String?

      plugin.handle_event("onAppear", args: nil) { response = $0 }

      #expect(response == nil)
    }

    @Test func bundlesJavaScriptRegisteringPlugin() async throws {
      let js = JLPluginOpenTelemetry.Plugin().js()

      #expect(!js.isEmpty)
      #expect(js.contains("window.jasonelle.plugins.opentelemetry"))
      #expect(js.contains("counter.add"))
      #expect(js.contains("histogram.record"))
    }
}
