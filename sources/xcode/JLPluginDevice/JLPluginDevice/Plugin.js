//
//  Plugin.js
//  JLPluginDevice
//
//  Created by Camilo on 05-09-26.
//

(() => {
  const native = window.jasonelle;
  const plugin = {
    name: "com.jasonelle.plugins.device"
  };

  console.log("Device Plugin Jasonelle Init");

  plugin.call = (...args) => native.post(plugin.name, args);

  plugin.handle = (args) => {
    console.log("Device info:", args);
    return true;
  };

  window.jasonelle.plugins.device = plugin;
})();
