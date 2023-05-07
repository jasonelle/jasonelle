/*--automatically-generated-by-esbuild--*/
(() => {
  // JS/webview.js
  var appendViewPort = (window2, document2, force = false) => {
    const viewport = document2.querySelector("meta[name=viewport]");
    if (!force && viewport) {
      window2.$logger.trace("Viewport exists. Not overriding it");
      return;
    }
    const content = `width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no`;
    if (!viewport) {
      window2.$logger.trace("Viewport does not exists. Creating one.");
      const meta = document2.createElement("meta");
      meta.name = "viewport";
      meta.content = content;
      const head = document2.getElementsByTagName("head")[0];
      head.appendChild(meta);
      return;
    }
    window2.$logger.trace("Overriding Viewport");
    viewport.setAttribute("content", content);
  };
  if (typeof window != "undefined" && typeof document != "undefined") {
    window.jasonelle.ready = true;
    window.$agent = window.jasonelle.agent;
    window.$logger = window.jasonelle.logger;
    if (document.getElementById("jasonelle.version")) {
      document.getElementById("jasonelle.version").innerHTML = "Jasonelle v" + window.jasonelle.version.string;
    }
    appendViewPort(window, document, false);
    const event = new CustomEvent("com.jasonelle.events.ready", {
      detail: {
        ready: true,
        jasonelle: window.jasonelle
      }
    });
    document.dispatchEvent(event);
  }
})();
