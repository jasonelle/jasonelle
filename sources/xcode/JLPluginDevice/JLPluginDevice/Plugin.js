//
//  Plugin.js
//  JLPluginDevice
//
//  Created by Camilo on 05-09-26.
//

(() => {
  const native = window.jasonelle;
  const plugin = {
    name: "device",
    id: "com.jasonelle.plugins.device"
  };

  console.log("Device Plugin Jasonelle Init");

  // Call a native function. The response is passed to the callback
  // Example: window.jasonelle.plugins.device.call().then(response => console.log(response))
  plugin.call = (...args) => native.post(plugin.id, args);

  window.jasonelle.plugins.device = plugin;
})();
