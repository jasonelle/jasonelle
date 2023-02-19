## Extension Coding

When coding an extension you can access some events and properties
that will enable to add new features to _Jasonelle_.

### `- (void) install`

This method will be executed when installing the extension in `AppDelegate` lifecycle. This is before all the extensions are ready, 
because a single extension is being installed at the time.

Be sure to call the `[super install]` method.

```objective-c
- (void) install {
    [super install];
    // your code here
}
```

#### `self.handlers`

The handlers are the names of the native bridges that will be called when used inside the webview. Must be configured in the `install` method.

See [JLKeychain](https://github.com/jasonelle/jasonelle/tree/main/sources/xcode/Extensions/JLKeychain) extension as an example with using handlers.


```objective-c
- (void) install {
  // ...
  self.handlers = @{
        @"$keychain.set": setHandler,
        @"$keychain.get": getHandler,
        @"$keychain.remove": removeHandler,
        @"$keychain.clear": clearHandler
    };
}
```

##### Handlers

A handler is a native function that is called within the webview.

Handlers will be called using `$agent.trigger()` inside the webview.

- Example: `$agent.trigger('$keychain.get')`

They will return a [`JS Promise`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Promise).

A wrapper can be created to call directly.

- Example: [**JLContacts.js**](https://github.com/jasonelle/jasonelle/blob/main/sources/xcode/Extensions/JLContacts/JLContacts/JLContacts.js)

```js
 (() => {
     if (window && window.$myextension) {
         return;
     }
     
     window.$myextension = {};
     window.$myextension.run = () => $agent.trigger("$myextension.run", {});
 })();
```


### `- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions`

This method is called in `AppDelegate` after the setup and before loading the webview. Normally for post install logic. All the other extensions would be available at this point.

### `- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView`

This method is called when the `WKWebView` is ready. You can use it to 
inject _JavaScript_ files or make additional configurations to the webview element.

```objective-c
- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    return webView;
}
```

#### Examples

See [JLCookies](https://github.com/jasonelle/jasonelle/tree/main/sources/xcode/Extensions/JLCookies) as an example extension that only loads a _JS_ file.

### More methods

See which other methods are available in [JLApplicationExtensions](https://github.com/jasonelle/jasonelle/blob/main/sources/xcode/Jasonelle/JLKernel/JLKernel/Application/Extensions/JLApplicationExtensions.h)

### FileSystem Helper

You can access the filesystem by using the `app.utils.fs` helper.

**Example**

Reads a file named _JLContacts.js_ inside the self bundle.

```objective-c
NSString * js = [self.app.utils.fs
                     readJS:@"JLContacts"
                     for:self];

// If is named the same as the class then can be used like this
NSString * js = [self.app.utils.fs
                     readJSFor:self];
```

### WebView Helper

To help injecting scripts to webview you can use `app.utils.webview` helper.

```objective-c
webView = [self.app.utils.webview inject:@"js.cookie.min" intoWebView:webView for:self];

// Reads the filename as Classname.js
return [self.app.utils.webview inject:self intoWebView:webView];
```

### Extension Service Locator

You can fetch the extension instance by using the `app.ext` service locator.

```objective-c
return (JLATTrackingManager *) [self.app.ext get:JLATTrackingManager.class];

return (JLApplicationBadge *) [self.app.ext get:JLApplicationBadge.class];
```
