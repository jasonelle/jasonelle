// Our initial Screen

import {
    Color,
    Component,
    i18n as _t,
    Logger,
    openURL,
} from "@jasonelle/kernel";

const Paint = Color.Factory;

// TODO: Add more configuration options
// Configuration related to the renderer WebViewRendererUI

const log = (message) => {
    Logger.trace(message, { source: "main.js", console: true });
};

const HOME_URL = "res://examples.html";

class MainScreen extends Component {
    url = HOME_URL;
    fallback = "res://no-connection.html";

    style = {
        bounces: true,
    };

    // View components
    components = {
        // Scissor comment to enable/disable the pull to refresh
        /*
        pull: {
            title: _t("main.pull.title", "Pull to Refresh"),
            hidden: false,
            style: {
                color: Paint("blue"),
                tint: Paint("orange"),
            },
            options: {
                // TODO: Add option to hide the progress bar
            },
            hooks: {
                // pull gets called whenever user makes a pull to refresh action
                onPull(event) {
                    log(event);
                    log("Pulled Event");
                },
            },
        },
        // */
    };

    //    headers = {};
    //    cookies = {};

    // Actions are available in the webview to be called
    // Using $agent.call("hello", params);
    // TODO: For now it can't handle promises. Only return primitive types
    actions = {
        hello: function(params = {}) {
            log("Hello World Action " + JSON.stringify(params));
            return true;
        },
        safari: function(url) {
            log("Opening Safari " + url);
            // available protocols
            // sms, email, phone, facetime, app
            openURL.app(url);
            return true;
        },
        home: function() {
            log("Returning " + HOME_URL);
            return HOME_URL;
        },
    };

    // Hooks are events that are triggered when something happens
    // in the app.
    // TODO: Maybe add a way to call webview js functions from here
    hooks = {
        // Custom event from MyExtension
        //                onExampleEvent(message) {
        //                    log(message);
        //                },

        /*************************************************************
        *
        ## Event Handlers Rule ver2.
        ##
        ## 1. When there's only $show handler
        ## - $show: Handles both initial load and subsequent show events
        ##
        ## 2. When there's only $load handler
        ## - $load: Handles Only the initial load event
        ##
        ## 3. When there are both $show and $load handlers
        ## - $load : handle initial load only
        ## - $show : handle subsequent show events only
        ##
        ##
        ## Summary
        ##
        ## $load:
        ## - triggered when view loads for the first time.
        ## $show:
        ## - triggered at load time + subsequent show events (IF $load handler doesn't exist)
        ## - NOT triggered at load time BUT ONLY at subsequent show events (IF $load handler exists)
        ##
        *************************************************************/

        /*
         $load gets called once automatically when the view loads for the first time.

         Here's an example where we make a network request when the view loads, and then render the response using the template.
         */
        onLoad(event) {
            log(event);
        },
        /*
         $show gets called automatically whenever the view appears. For example when coming back from a modal view, coming back from its next view via back button, etc.
         */
        onAppear(event) {
            log(event);
        },

        onDisappear(event) {
            log(event);
        },

        /*
         $foreground is called automatically whenever the app comes back from the background state.
         */
        onForeground(event) {
            log(event);
        },

        onBackground(event) {
            log(event);
        },
        //        onPushNotification(event) {},

        // These methods would enable these listeners
        // as they are not enabled by default

        // Triggered by Device Orientation
        // see: https://developer.apple.com/documentation/uikit/uidevice?language=objc
        //        onOrientationChange(event) {
        //            log(event);
        //        },

        //        // Triggered by Device Battery
        //        onBatteryStatusChange(event) {
        //        },
        //
        //        // Triggered by Device Proximity
        //        onProximityStatusChange(event) {
        //        },
        //
        //        // Triggered when reachability changes
        //        onNetworkingReachabilityChange(event) {
        //        },
        //
        //        // Triggered when using URL Schemes
        //        onURLSchemeOpen(event) {
        //        },
    };
}

// Export a function so it can receive props on constructor
export default (props = {}) => new MainScreen(props);
