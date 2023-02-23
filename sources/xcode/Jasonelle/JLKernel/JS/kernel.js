// TODO: Add http fetch or similar requests native bridge
import App from "./app";
import Logger from "./logger";

// Color helper
// https://www.npmjs.com/package/color
import Color from "./color";

// UUID helper
// https://www.npmjs.com/package/uuid
import Component from "./component";
import UUID from "./uuid";

// TODO: improve router
import Route from "./router";

import i18n from "./i18n";
import openURL from "./openurl";

Logger.trace("JS Kernel ready", { source: "com.jasonelle.js.kernel" });

export { Logger };
export { App };
export { Color };
export { UUID };
export { Component };
export { Route };
export { i18n };
export { openURL };

export default {
    Logger,
    App,
    Color,
    UUID,
    Component,
    Route,
    i18n,
    openURL,
};
