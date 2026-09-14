//
//  Plugin.js
//  JLPluginCookies
//
//  Created by Camilo on 07-09-26.
//

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
