//
//  ApplicationApp.swift
//  Application
//
//  Created by Camilo on 19-08-26.
//

import SwiftUI
import JLKernel

@main
struct Main: App {
    private let logger: JLKernel.Logger = .init(from: Main.self)
  
    var body: some Scene {
        WindowGroup {
          ContentView().onAppear {
            viewDidAppear()
          }
        }
    }
  
  func viewDidAppear() {
    JLKernel.Kernel.logo()
    JLKernel.Logger.level = .debug
    
    logger.debug("Init")
    
    for (name, plugin) in plugins {
      logger.debug("\(name) js():\n\(plugin.js())")
    }
  }
}
