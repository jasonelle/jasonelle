//
//  Component.swift
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
import Jasonelle
import JLKernel

// These are stored inside the JS, get the object associated with them
class PullComponent {
    let app: Jasonelle.App
    let params: PullParams
    let hooks: PullHooks
    let style: PullStyle
    let strings = PullStrings.self

    init(_ app: Jasonelle.App, params: JLJSParams) {
        self.app = app
        self.params = PullParams(params)
        hooks = PullHooks(app.events, params: self.params)
        style = PullStyle(self.params)
    }
}
