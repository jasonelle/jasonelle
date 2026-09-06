//
//  Plugin.js
//  JLPluginHello
//
//  Created by Camilo on 19-08-26.
//

(() => {
  const native = window.jasonelle;
  const plugin = {
    name: "hello",
    id: "com.jasonelle.plugins.hello"
  };
  
  console.log("Hello World Plugin Jasonelle Init");
  
  // Call a native function. The response is passed to the callback
  // Example: window.jasonelle.plugins.hello.call().then(response => console.log(response))
  plugin.call = (...args) => native.post(plugin.id, args);

  // Listen for events from native code
  plugin.handle = (args) => {
    console.log("Handled in Webview with args:", args);
    return true
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

