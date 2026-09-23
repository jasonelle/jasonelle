(() => {
  const native = window.jasonelle;
  const plugin = native.plugin.init("stub", "com.jasonelle.plugins.stub");

  plugin.handle = (args) => {
    console.log("Handled in Webview with args:", args);
    return true;
  };

  window.jasonelle.plugins.stub = plugin;
})();