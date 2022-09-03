// app.js
// the main application file
// These files are then bundled by esbuild
// and the output will be inside App/_build directory.
// You can use any supported js by esbuild
// That can be used in browser

import Config from "./config";
import Router from "./lib/router";

// == WARNING
// Please do not touch beyond this point
// if you don't know what is happening here

import Jasonelle from "@jasonelle";
import { App, Logger } from "@jasonelle/kernel";

// app is the context that can be called from the native bridges
App.Jasonelle = Jasonelle;
App.Config = Config;
App.Logger = Logger;
App.Router = Router;

Logger.trace("app.js ready", {
    source: "com.jasonelle.js.app",
});
