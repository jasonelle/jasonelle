// webview.js
// this file will be injected
// to any webview used in the app.
// These files are then bundled by esbuild
// and the output will be inside App/_build directory.
// You can use any supported js by esbuild
// That can be used in browser.

// This code is executed after the browsers triggers the `DOMContentLoaded` JS Event

// Some websites need a small viewport fix
// You can disable this if is not needed
const appendViewPort = (window, document, force = false) => {
    const viewport = document.querySelector("meta[name=viewport]");

    // Respect the original viewport
    // if not forced
    if (!force && viewport) {
        window.$logger.trace("Viewport exists. Not overriding it");
        return;
    }

    const content =
        `width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no`;

    if (!viewport) {
        // If the website does not already have the viewport
        // maybe it will need scrolling to the top after loading
        window.$logger.trace("Viewport does not exists. Creating one.");

        const meta = document.createElement("meta");
        meta.name = "viewport";
        meta.content = content;

        const head = document.getElementsByTagName("head")[0];
        head.appendChild(meta);
        return;
    }

    window.$logger.trace("Overriding Viewport");
    viewport.setAttribute("content", content);
};

// Dispatch that Jasonelle was Injected Successfully
if (typeof window != "undefined" && typeof document != "undefined") {
    // So you can check if this is executing inside jasonelle
    window.jasonelle.ready = true;
    window.$agent = window.jasonelle.agent;
    window.$logger = window.jasonelle.logger;

    if (document.getElementById("jasonelle.version")) {
        document.getElementById("jasonelle.version").innerHTML = "Jasonelle v" +
            window.jasonelle.version.string;
    }

    // Add the viewport fix if needed
    appendViewPort(window, document, false);

    /*
     Usage:
     // Add an event listener
     document.addEventListener("com.jasonelle.events.ready", function(e) {
       console.log(e);
     });
     */

    // Create the event
    // see: https://developer.mozilla.org/en-US/docs/Web/API/CustomEvent/detail
    const event = new CustomEvent("com.jasonelle.events.ready", {
        detail: {
            ready: true,
            jasonelle: window.jasonelle,
        },
    });

    // Dispatch/Trigger/Fire the event
    document.dispatchEvent(event);
}
