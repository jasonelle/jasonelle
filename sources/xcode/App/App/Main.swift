//
//  AppApp.swift
//  App
//
//  Created by clsource on 01-02-22
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

import SwiftUI
import Jasonelle

// Import the View Renderer
// It has the mission to display the contents
// The WebViewRendererUI is just a webView
// That will load a url defined in the configs
import WebViewRendererUI

@main
struct Main: SwiftUI.App {
    
    // Configure The AppDelegate
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var app = Jasonelle.App.instance
    
    init() {
        // This executes before the app delegate
        // So we can´t use the logger
        print("Booting up Jasonelle v\(JASONELLE_VERSION_STRING)")
    }
    
    var body: some Scene {
        WindowGroup {
            // Display View Renderer's View
            WebViewRendererUI.ContentView()
        }
    }
}
