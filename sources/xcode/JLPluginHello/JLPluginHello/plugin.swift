//
//  JLPluginHello.swift
//  JLPluginHello
//
//  Created by Camilo on 19-08-26.
//

import Foundation
import JLKernel

public class Plugin {
  public static func hello() {
    JLKernel.Kernel.logo()
  }
}
