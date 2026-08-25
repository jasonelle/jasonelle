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
  
    init() {
        JLKernel.Kernel.logo()
        JLKernel.Logger.level = .debug
        logger.info("App Initiated")
    }
  
    var body: some Scene {
        WindowGroup {
          ContentView().onAppear {
            logger.info("View did appear")
          }
        }
    }
}
