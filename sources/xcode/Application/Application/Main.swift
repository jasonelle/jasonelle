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
        // Purchase a License in https://jasonelle.com
        // to help development efforts.
        JLKernel.License.verify(key: "PURCHASE_ME")
        JLKernel.Events.register(plugins: plugins)
        logger.info("App Initiated")
    }

    var body: some Scene {
        WindowGroup {
          ContentView().onAppear {
            logger.info("View did appear")

            JLKernel.Events.sendOnAppear()
          }
        }
    }
}
