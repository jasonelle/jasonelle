//
//  AppApp.swift
//  App
//
//  Created by clsource on 01-02-22
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
            
            // Add here final UI corrections
            // .none, .light or .dark
            .preferredColorScheme(.dark)
            
            // Some websites may need this, specially when using a navbar.
            // If you need this, enable one of these options
            // .ignoresSafeArea(.container)
            //.edgesIgnoringSafeArea(.bottom)
            
            // Add a little padding if needed
            //.padding(.bottom, (UIApplication.shared.windows.first?.safeAreaInsets.bottom ?? 0) / 10)
        }
    }
}
