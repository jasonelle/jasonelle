//
//  Params.swift
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

// Get the properties defined in the JS of the component

class PullHooksParams {
    let params: JLJSParams

    init(_ params: JLJSParams) {
        self.params = params
    }

    func onPull() -> JLJSParams {
        return params.get("onPull")
    }
}

class PullParams {
    let params: JLJSParams
    // Initialize with the params at the `pull` level
    init(_ params: JLJSParams) {
        self.params = params
    }

    func style() -> JLJSParams {
        return params.get("style")
    }

    func title() -> String {
        return params.string("title", default: PullStrings.defaultTitle())!
    }
    
    func hidden() -> Bool {
        return params.boolean("hidden")
    }

    func hooks() -> PullHooksParams {
        return PullHooksParams(params.get("hooks"))
    }
}
