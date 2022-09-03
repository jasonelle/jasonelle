// webview.js
// this file will be injected
// to any webview used in the app.
// These files are then bundled by esbuild
// and the output will be inside App/_build directory.
// You can use any supported js by esbuild
// That can be used in browser.

// This code is executed after the browsers triggers the `DOMContentLoaded` JS Event

// Dispatch that Jasonelle was Injected Successfully
if (typeof window != "undefined" && typeof document != "undefined") {
    // So you can check if this is executing inside jasonelle
    window.jasonelle.ready = true;
    window.$agent = window.jasonelle.agent;
    window.$logger = window.jasonelle.logger;

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
