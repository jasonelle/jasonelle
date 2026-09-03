//
//  ContentView.swift
//  Application
//
//  Created by Camilo on 19-08-26.
//

import SwiftUI
import JLKernel

struct ContentView: View {
    var body: some View {
      ZStack {
        JLKernel.WebView.fromConfiguration(plugins: plugins)
      }
    }
}

#Preview {
    ContentView()
}
