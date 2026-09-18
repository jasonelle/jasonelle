//
//  JLKernel/License.swift
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-06
//  Made with love in Chile.
//
//  Copyright (c) Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels at https://jasonelle.com.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.

import Foundation
import UIKit

public class License {

  private let logger: Logger = .init(from: License.self)

  private var key: String?
  private let isInSimulator: () -> Bool

  public init(
    key: String? = nil,
    isInSimulator: @escaping () -> Bool = {
#if targetEnvironment(simulator)
      return true
#else
      return false
#endif
    }
  ) {
    self.key = key
    self.isInSimulator = isInSimulator
  }

  private func isValid() -> Bool {
    let key = self.key
    let isEmpty = key?.isEmpty == true
    let isBlank = key?.trimmingCharacters(in: .whitespacesAndNewlines) == ""
    return !(key == nil || isEmpty || isBlank || key == "PURCHASE_ME")
  }

  public func abortIfIsInSimulator() {
    if self.isInSimulator() {
      if !self.isValid() {
        self.logger.info("Running in simulator. Please consider purchasing a license at https://jasonelle.com")
      }
      return
    }
    let error: String = "License is not set. Running in Device is not allowed without a license. Can only use in simulator. Adquire an official license at https://jasonelle.com"
    self.logger.emergency(error)
    fatalError(error)
  }

  public func check() {
    if self.isValid() {
      self.logger.info("License found. Thank you for supporting Jasonelle development ♥.")
      return
    }
    abortIfIsInSimulator()
  }

  public static func verify(key: String? = "") {
    let license = License.init(key: key)
    license.check()
  }
}
