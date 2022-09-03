//
//  Styles.swift
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
import UIKit

// Return properties that will be colored or need UI configurations
class PullStyle {
    let params: PullParams
    init(_ params: PullParams) {
        self.params = params
    }

    func title() -> NSAttributedString {
        let titleWithColor = NSAttributedString(string: params.title(), attributes: [
            NSAttributedString.Key.foregroundColor: color(from: "color", default: UIColor.black),
        ])

        return titleWithColor
    }

    func tint() -> UIColor {
        return color(from: "tint", default: UIColor.black)
    }

    // TODO: Move this to a lib in Kernel
    private func color(from: String, default _: UIColor) -> UIColor {
        let max: NSNumber = 255
        let maxFloat = CGFloat(max.floatValue)

        let rgb = params.style().get(from)
        let red = rgb.number("r", default: 0)!.floatValue
        let green = rgb.number("g", default: 0)!.floatValue
        let blue = rgb.number("b", default: 0)!.floatValue
        let alpha = rgb.number("a", default: max)!.floatValue

        return UIColor(red: CGFloat(red) / maxFloat, green: CGFloat(green) / maxFloat, blue: CGFloat(blue) / maxFloat, alpha: CGFloat(alpha) / maxFloat)
    }
}
