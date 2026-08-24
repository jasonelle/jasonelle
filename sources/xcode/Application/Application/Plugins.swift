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
public let plugins : [String : JLPlugin] = [
  String(reflecting: type(of: JLPluginHello.Plugin.self)) : JLPluginHello.Plugin()
]
