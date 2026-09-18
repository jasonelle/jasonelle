//
//  Application/ContentView.kt
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

import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Surface
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.remember
import androidx.compose.ui.Modifier
import androidx.compose.ui.platform.LocalContext
import com.jasonelle.kernel.AppConfiguration
import com.jasonelle.kernel.ConfigurationException
import com.jasonelle.kernel.ConfigurationLoader
import com.jasonelle.kernel.Events
import com.jasonelle.kernel.JasonelleWebView
import com.jasonelle.kernel.Logger

@Composable
fun contentView() {
  val context = LocalContext.current
  val config =
    remember {
      try {
        ConfigurationLoader.load(context)
      } catch (e: ConfigurationException) {
        Logger(subsystem = "ContentView").error("Failed to load configuration: ${e.message}, falling back to about:blank")
        AppConfiguration(urlString = "about:blank")
      }
    }

  LaunchedEffect(Unit) {
    Events.sendOnAppear()
  }

  MaterialTheme {
    Surface(modifier = Modifier.fillMaxSize()) {
      JasonelleWebView(
        config = config,
        plugins = Events.plugins,
        modifier = Modifier.fillMaxSize(),
      )
    }
  }
}
