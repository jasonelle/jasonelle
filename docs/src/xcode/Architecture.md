# Architecture

Jasonelle's architecture is mainly composed of two different [JavaScript Contexts](https://developer.apple.com/documentation/javascriptcore/jscontext). One is in the _Kernel_ and the other is in the [_WKWebView_](https://developer.apple.com/documentation/webkit/wkwebview) instance.

## JLKernel

The _JLKernel_ is the main project for bootstrapping _Jasonelle_. It allows to
communicate with the _WKWebView_ and other tasks.

### JSEngine

It's main tasks are:

- Load configurations and other Javascript files, evaluate them and return the results.
- Inject Javascript code to a Kernel Javascript Context (separated from the WebView).
- Can use [node_modules](https://nodejs.org/docs/v0.4.1/api/modules.html) to allow use of external dependencies (they must be web browser compatible).

You can use the _JSEngine_ by modifing the [`main.js.`](https://github.com/jasonelle/jasonelle/blob/main/sources/xcode/App/JS/lib/screens/main.js) file.

#### main.js

The `main.js` file is capable of the following:

- Import code from `node_modules`.
- Define new `actions` than can be called from the webview using `$agent.call()`.
- Listen to native events in `hooks`.
- Configure native components (`$pull`).

#### Built-in JS Functions
Some of the built-in functions are the following:

- `i18n`: Enables using native translation strings functions. So you can translate using [Localizable.strings](https://developer.apple.com/documentation/xcode/adding-support-for-languages-and-regions/) files.
- `color`: Enables generating colors in native formats.
- `uuid`: Enables generating `uuidv4` strings.
- `log`: Enables logging with native logger.
- `openURL`: Enables opening an URL like `sms://`, `tel://`, `mailto://`, `facetime://`.

## WebViewRenderer

Is the project that will render the `WKWebView`. You can inject Javascript code directly using the [`webview.js`](https://github.com/jasonelle/jasonelle/blob/main/sources/xcode/App/JS/webview.js) file.

**Extensions** will be mainly interacting with this component to inject new native functionality.

This is the `Web Browser`, it will have access to all your Javascript files and DOM. You can use it to modify behaviours and pass special params.

The following variables are injected to `window` by default:

- `$agent`: Use this to call methods defined in _Extensions_ and `main.js`.
- `$logger`: Use this to call the native logger.
- `jasonelle`: This variable contains info like _Jasonelle_'s version. Use this to detect if you are inside a _Jasonelle Web Wrapper_ in your website.

```js
if (window.jasonelle && window.jasonelle.ready) {
  // Jasonelle Detected
}
```
