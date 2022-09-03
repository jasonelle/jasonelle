//
//  Parser.swift
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

// Params for the Main Component
class Params {
    let params: JLJSParams
    let app: Jasonelle.App

    init(app: Jasonelle.App, params: JLJSParams) {
        self.app = app
        self.params = params
    }

    func hooks() -> Hooks {
        return Hooks(app.events, params: params.get("hooks"))
    }

    func actions(context: JSContext) -> Actions {
        let contx = JLJSContext(context: context, andLogger: app.logger)
        return Actions(context: contx, params: params.get("actions"))
    }

    func url() -> String {
        return params.string("url", default: "about:blank")!
    }

    func components() -> Components {
        return Components(app, params: params.get("components"))
    }

    func style() -> Style {
        return Style(params.get("style"))
    }
}
