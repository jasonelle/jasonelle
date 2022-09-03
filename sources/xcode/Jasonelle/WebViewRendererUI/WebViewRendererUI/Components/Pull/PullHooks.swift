//
//  Hooks.swift
//  WebViewRendererUI
//
//  Created by clsource on 24-04-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  https://mozilla.org/MPL/2.0/.
//

import Foundation
import JLKernel

class PullHooks {
    let events: JLApplicationEvents
    let params: PullHooksParams

    init(_ events: JLApplicationEvents, params: PullParams) {
        self.params = params.hooks()
        self.events = events
    }

    // Should be manually called on the refesh control events
    func onPull() {
        let event = params.onPull()
        let function = event.value
        function.secureCall(with: JLUserInfo.withName("com.jasonelle.events.webrendererui.hooks.pull.onPull"))
    }
}
