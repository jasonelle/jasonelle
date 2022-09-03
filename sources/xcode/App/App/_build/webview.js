/*--automatically-generated-by-esbuild--*/
(() => {
  // JS/webview.js
  if (typeof window != "undefined" && typeof document != "undefined") {
    window.jasonelle.ready = true;
    window.$agent = window.jasonelle.agent;
    window.$logger = window.jasonelle.logger;
    const event = new CustomEvent("com.jasonelle.events.ready", {
      detail: {
        ready: true,
        jasonelle: window.jasonelle
      }
    });
    document.dispatchEvent(event);
  }
})();
