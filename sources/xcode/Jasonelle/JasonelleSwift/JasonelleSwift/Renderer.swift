//
//  Renderer.swift
//  WebViewRendererUI
//
//  Created by clsource on 06-02-22
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

/// Conforms to JLRendererProtocol
/// And is passed down to the Application container
public class Renderer: NSObject, JLRendererProtocol {
    public var view: Any?
    var app = Jasonelle.App.instance
    var logger = Logger()

    override public init() {
        view = nil
    }
}
