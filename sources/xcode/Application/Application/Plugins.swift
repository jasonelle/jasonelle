//
//  Plugins.swift
//  Application
//
//  Created by Camilo on 22-08-26.
//

import JLKernel

// PLUGINS.IMPORT
import JLPluginHello


// PLUGINS.INIT
// Keys must match the plugin name registered in JS (window.jasonelle.plugins.<name>)
public let plugins : [String : JLPlugin] = [
  JLPluginHello.Plugin.name: JLPluginHello.Plugin()
]
