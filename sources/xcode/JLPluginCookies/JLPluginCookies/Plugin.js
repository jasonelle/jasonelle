//
//  JLPluginCookies/Plugin.js
//
//  Created by [Camilo Castro (@clsource)](https://ninjas.cl) on 2026-09-07
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
  const plugin = native.plugin.init("cookies", "com.jasonelle.plugins.cookies");

  // Store a cookie string in the iOS keychain
  // Example: window.jasonelle.plugins.cookies.save("session=abc; Path=/")
  plugin.save = (value) => native.post(plugin.id, { action: "save", value });

  // Restore the cookie string from the keychain and inject it into the webview
  // after the DOM has loaded. The response resolves with { status, value }.
  plugin.restore = () => native.post(plugin.id, { action: "restore" }).then((response) => {
    console.log("cookies: searching for saved cookies");
    if (response.status === "ok" && response.value) {
      console.log("cookies: restored saved cookies");
      document.cookie = response.value;
    }
    return response;
  });

  // Store the current webview cookies in the iOS keychain
  plugin.persist = () => plugin.save(document.cookie);

  // Register JS functions globally
  window.jasonelle.plugins.cookies = plugin;
})();
