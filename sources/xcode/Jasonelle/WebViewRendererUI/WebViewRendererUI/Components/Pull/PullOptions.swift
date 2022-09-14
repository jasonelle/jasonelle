//
//  PullOptions.swift
//  WebViewRendererUI
//
//  Created by clsource on 14-09-22
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
import UIKit

class PullOptions {
    let params: PullParams
    init(_ params: PullParams) {
        self.params = params
    }

    func hidden() -> Bool {
        return self.params.params.boolean("hidden")
    }
}
