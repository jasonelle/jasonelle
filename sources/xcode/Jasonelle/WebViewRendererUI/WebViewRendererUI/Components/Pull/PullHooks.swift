//
//  Hooks.swift
//  WebViewRendererUI
//
//  Created by clsource on 24-04-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
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
