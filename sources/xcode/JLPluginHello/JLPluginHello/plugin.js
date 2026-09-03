//
//  Plugin.js
//  JLPluginHello
//
//  Created by Camilo on 19-08-26.
//

(() => {
  const native = window.jasonelle;
  const plugin = {
    name: "com.jasonelle.plugins.hello"
  };
  
  console.log("Hello World Plugin Jasonelle Init");
  
  // Demostrate calling a native function
  plugin.call = (...args) => {
    native.post(plugin.name, args);
  };
  
  // Demostrate listening to an event
  plugin.handle = (args) => {
    console.log("Handled in Webview with args:", args);
    return true
  };
  
  // Demostrate HTML manipulation
  // Add buttons to HTML
  const button = document.createElement("button");
  button.textContent = "Click Me";
  button.addEventListener("click", () => plugin.call("Hello", "World"));
  document.body.append(button);
  
  // Register JS functions globally
  window.jasonelle.plugins.hello = plugin;
})();

