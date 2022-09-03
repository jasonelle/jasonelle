//
//  Actions.swift
//  WebViewRendererUI
//
//  Created by clsource on 08-05-22
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

class Actions {
    let params: JLJSParams
    let context: JLJSContext

    init(context: JLJSContext, params: JLJSParams) {
        self.params = params
        self.context = context
    }
}
