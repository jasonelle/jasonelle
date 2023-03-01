//
// agent.js
// Defines the agent object that will be injected in every webview
//
(() => {
    if(window && window.__com_jasonelle_agent) {
        return;
    }
    
    const __com_jasonelle_agent = {
        // Unique id defined on the WebView to implement the message handler
        id: "",
        // Interface object to call the message handler
        interface: {},
        // Part of the old RPC
        // callbacks: {}
    };

    // This is the RPC of the old way.
    // Maybe is not needed anymore since iOS >= 14 can use Promises
    // Make requests to another agent
    // __com_jasonelle_agent.request = function(rpc, callback) {
    //
    //    // set nonce to only respond to the return value I requested for
    //    const nonce = Math.random().toString(36).substring(2, 15) + Math.random().toString(36).substring(2, 15);
    //
    //    __com_jasonelle_agent.callbacks[nonce] = function(data) {
    //        // Execute the callback
    //        callback(data);
    //
    //        // Delete itself to free up memory
    //        delete __com_jasonelle_agent.callbacks[nonce];
    //    };
    //
    //    // Send message
    //    return __com_jasonelle_agent.interface.postMessage({
    //                                 request: { data: rpc, nonce: nonce }
    //                                 });
    //
    // };
    //
    //// Return response to Jasonelle or the caller agent
    // __com_jasonelle_agent.response = function(data) {
    //    return __com_jasonelle_agent.interface.postMessage({
    //                                 response: { data: data }
    //                                 });
    // };

    // Enable extension handlers to listen to messages
    __com_jasonelle_agent.__post = function(params) {
        return __com_jasonelle_agent.interface.postMessage(params);
    };

    // Directly call without a dictionary
    __com_jasonelle_agent.__callNative = function(name, options = {}) {
        const params = {};
        params[name] = options;
        return __com_jasonelle_agent.__post(params);
    };

    // Handled only by Jasonelle Core
    __com_jasonelle_agent.__kernelcall = function(name, options = {}) {
        return __com_jasonelle_agent.__callNative("com.jasonelle.agent.kernel", {
            name,
            options,
        });
    };

    // Public

    // Handled by app.js actions
    __com_jasonelle_agent.call = function(name, options = {}) {
        return __com_jasonelle_agent.__callNative("com.jasonelle.agent.action", {
            name,
            options,
        });
    };

    // Handled by Extensions
    __com_jasonelle_agent.trigger = function(name, options = {}) {
        return __com_jasonelle_agent.__callNative("com.jasonelle.agent.trigger", {
            name,
            options,
        });
    };

    // Logger

    __com_jasonelle_agent.logging = {};
    __com_jasonelle_agent.logging.log = function(message, options = {}) {
        return __com_jasonelle_agent.__kernelcall("JLJSLoggerMessageHandler", {
            message,
            options,
        });
    };

    __com_jasonelle_agent.logging.level = {
        trace: "trace",
        debug: "debug",
        info: "info",
        notice: "notice",
        warning: "warning",
        error: "error",
        critical: "critical",
    };

    __com_jasonelle_agent.logging.logger = {
        log(message, options = {
            func: null,
            line: null,
            source: "com.jasonelle.webview.logger",
            console: true,
        }) {
            const params = { message, options };

            if (options.console) {
                if (options.source) {
                    console.log(options.source, params);
                } else {
                    console.log(params);
                }
            }

            return __com_jasonelle_agent.logging.log(message, options);
        },

        trace(
            message,
            options = {},
        ) {
            return this.log(message, {
                level: __com_jasonelle_agent.logging.level.trace,
                ...options,
            });
        },

        debug(
            message,
            options = {},
        ) {
            return this.log(message, {
                level: __com_jasonelle_agent.logging.level.debug,
                ...options,
            });
        },

        info(
            message,
            options = {},
        ) {
            return this.log(message, { level: Level.info, ...options });
        },

        notice(
            message,
            options = {},
        ) {
            return this.log(message, {
                level: __com_jasonelle_agent.logging.level.notice,
                ...options,
            });
        },

        warning(
            message,
            options = {},
        ) {
            return this.log(message, {
                level: __com_jasonelle_agent.logging.level.warning,
                ...options,
            });
        },

        error(
            message,
            options = {},
        ) {
            return this.log(message, {
                level: __com_jasonelle_agent.logging.level.error,
                ...options,
            });
        },

        critical(
            message,
            options = {},
        ) {
            return this.log(message, {
                level: __com_jasonelle_agent.logging.level.critical,
                ...options,
            });
        },
    };
    
    // Export
    window.__com_jasonelle_agent = __com_jasonelle_agent;
})();
