//
//  JLLicense.swift
//  JLKernel
//
//  Created by Camilo on 26-08-26.
//

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
    let error: String = "License is not set. Can only use in simulator. Adquire an official license at https://jasonelle.com"
    self.logger.emergency(error)
    fatalError(error)
  }

  public func check() {
    guard !self.isValid()  else {
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
