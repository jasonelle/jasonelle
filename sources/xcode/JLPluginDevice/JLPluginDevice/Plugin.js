//
//  Plugin.js
//  JLPluginDevice
//
//  Created by Camilo on 05-09-26.
//

(() => {
  const native = window.jasonelle;
  const plugin = native.plugin.init(
    "device",
    "com.jasonelle.plugins.device"
  );

  // Call a native function. The response is passed to the callback
  // Example: window.jasonelle.plugins.device.info().then(response => console.log(response))
  plugin.info = (...args) => native.post(plugin.id, args);

  window.jasonelle.plugins.device = plugin;
})();
