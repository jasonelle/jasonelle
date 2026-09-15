//
//  JLPluginHello/Plugin.js
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-08-19
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

(() => {
  const native = window.jasonelle;
  const plugin = native.plugin.init(
    "hello",
    "com.jasonelle.plugins.hello"
  );
  
  
  // Call a native function. The response is passed to the callback
  // Example: window.jasonelle.plugins.hello.call().then(response => console.log(response))
  plugin.call = (...args) => native.post(plugin.id, args);

  // Listen for events from native code
  plugin.handle = (args) => {
    console.log("Handled in Webview with args:", args);
    return true
  };

  // Print "Hello" to the console
  plugin.hello = () => {
    return native.post(plugin.id, {action: "hello"});
  };

  // Print "World" with params to the console
  plugin.world = (value = "Jasonelle") => {
    return native.post(plugin.id, {action: "world", args: value});
  };

  // Demostrate HTML manipulation
  // Add buttons to HTML
  const button = document.createElement("button");
  button.textContent = "Click Me";
  button.addEventListener("click", () => {
    plugin.call("Hello", "World").then(response => {
      console.log("Response:", response);
    });
  });
  document.body.append(button);
  
  // Register JS functions globally
  window.jasonelle.plugins.hello = plugin;
})();

