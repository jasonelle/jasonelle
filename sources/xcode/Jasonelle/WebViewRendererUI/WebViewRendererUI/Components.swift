//
//  Components.swift
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

// Which components are stored in the main component?
class Components {
    let params: JLJSParams
    let app: Jasonelle.App

    init(_ app: Jasonelle.App, params: JLJSParams) {
        self.app = app
        self.params = params
    }

    func pull() -> PullComponent {
        return PullComponent(app, params: params.get("pull"))
    }
}
