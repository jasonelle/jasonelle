//
//  WebViewRendererUIConfig.swift
//  WebViewRendererUI
//
//  Created by clsource on 15-04-22
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

import UIKit

class WebViewRendererUILoader {
    let app: Jasonelle.App
    let config: JLJSConfig
    let params: Params
    let logger: JLLoggerProtocol
    let hooks: Hooks
    let actions: Actions
    let style: Style
    let strings = Strings.self

    init(app: Jasonelle.App, context: JSContext) {
        self.app = app
        config = app.config.load()
        logger = app.logger

        params = Params(app: app, params: app.routes.load().params.get("/").get("component"))

        actions = params.actions(context: context)
        hooks = params.hooks()
        style = params.style()
    }
}
