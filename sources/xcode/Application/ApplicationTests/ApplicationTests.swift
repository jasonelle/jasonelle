//
//  ApplicationTests/ApplicationTests.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-08-19
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

import Testing
@testable import Application
import JLKernel
import JLPluginHello

struct ApplicationTests {

    @Test func pluginsNotEmpty() {
        #expect(!plugins.isEmpty)
    }

    @Test func helloPluginRegisteredWithCorrectKey() {
        let key = JLPluginHello.Plugin.id
        #expect(plugins[key] != nil)
    }

    @Test func helloPluginNameMatchesKey() {
        let key = JLPluginHello.Plugin.id
        let plugin = plugins[key]
        #expect(type(of: plugin!) == JLPluginHello.Plugin.self)
    }

    @Test func helloPluginRespondsToCall() async {
        let plugin = plugins[JLPluginHello.Plugin.id]
        let response = await withCheckedContinuation { continuation in
            plugin?.handle_call(callbackId: "call_1", args: nil) { result in
                continuation.resume(returning: result)
            }
        }
        #expect(!response.isEmpty)
    }

    @Test func helloPluginRespondsToEvent() async {
        let plugin = plugins[JLPluginHello.Plugin.id]
        let response = await withCheckedContinuation { continuation in
            plugin?.handle_event("viewDidLoad", args: nil) { result in
                continuation.resume(returning: result)
            }
        }
        #expect(response.contains("window.jasonelle.plugins.hello.handle"))
    }

}
