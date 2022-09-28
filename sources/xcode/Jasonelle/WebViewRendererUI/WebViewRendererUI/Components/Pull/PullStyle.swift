//
//  Styles.swift
//  WebViewRendererUI
//
//  Created by clsource on 24-04-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
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
