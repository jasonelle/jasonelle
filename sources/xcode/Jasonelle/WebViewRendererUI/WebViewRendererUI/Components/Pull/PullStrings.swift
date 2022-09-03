//
//  PullStrings.swift
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

class PullStrings {
    static func defaultTitle() -> String {
        return Bundle(for: Self.self).localizedString(forKey: "com.jasonelle.webviewrendererui.pull.title", value: "Pull to Refresh", table: nil)
    }
}
