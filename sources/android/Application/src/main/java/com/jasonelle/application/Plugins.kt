//
//  Application/Plugins.kt
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-15
//  Made with love in Chile.
//
//  Copyright (c) Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels at https://jasonelle.com.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/agpl-3.0.txt>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.

package com.jasonelle.application

import android.content.Context
import com.jasonelle.kernel.Plugin

// PLUGINS.INIT
// Keys must match the plugin id registered in JS (window.jasonelle.plugins.<name>)
fun createPlugins(context: Context): Map<String, Plugin> {
  // PLUGIN:JLPluginDevice
  val device =
    com.jasonelle.plugins.device
      .Plugin()
  // ENDPLUGIN
  // PLUGIN:JLPluginCookies
  val cookies =
    com.jasonelle.plugins.cookies
      .Plugin(context)
  // ENDPLUGIN
  // PLUGINS.INIT.EXTRA.VARS

  return mapOf(
    // PLUGIN:JLPluginDevice
    device.id to device,
    // ENDPLUGIN
    // PLUGIN:JLPluginCookies
    cookies.id to cookies,
    // ENDPLUGIN
    // PLUGINS.INIT.EXTRA.MAP
  )
}
