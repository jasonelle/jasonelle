//
//  Plugins.swift
//  Application
//
//  Created by Camilo on 22-08-26.
//

import JLKernel

// PLUGINS.IMPORT
import JLPluginHello
import JLPluginDevice
import JLPluginCookies
import JLPluginAppleSignIn

// PLUGINS.INIT
// Keys must match the plugin name registered in JS (window.jasonelle.plugins.<name>)
public let plugins: [String: JLKernel.Plugin] = [
  JLPluginHello.Plugin.id: JLPluginHello.Plugin(),
  JLPluginDevice.Plugin.id: JLPluginDevice.Plugin(),
  JLPluginCookies.Plugin.id: JLPluginCookies.Plugin(),
  JLPluginAppleSignIn.Plugin.id: JLPluginAppleSignIn.Plugin()
]
