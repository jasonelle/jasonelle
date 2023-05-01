# iOS Version

This small guide will help you getting started.

## Requirements

- XCode 13 or greater
- iOS 14 or greater

## Steps

### 1 - Download the project

Download [Bleeding Edge](https://github.com/jasonelle/jasonelle/archive/refs/heads/main.zip) or [Stable version](https://github.com/jasonelle/jasonelle/releases/latest).

- [Bleeding Edge](https://github.com/jasonelle/jasonelle/archive/refs/heads/main.zip): Latest updates, features and bug fixes. Built-in extensions enabled by default.

- [Stable version](https://github.com/jasonelle/jasonelle/releases/latest): Battle tested. Built-in extensions disabled by default.

Decompress and open `App.xcworkspace` file (White icon).

Find [`sources/xcode/App/JS/lib/screens/main.js`](https://github.com/jasonelle/jasonelle/blob/main/sources/xcode/App/JS/lib/screens/main.js).

### 2 - Configure your website

Put your URL for your application. This can be an external url or an HTML file. 

![webconfig](https://user-images.githubusercontent.com/292738/218337439-fd3db94b-0ae4-4b1f-adda-6df2e2eb50a8.png)


### Local Files

If you use `res://` you can access local html files such as the example `index.html`.

You can store local files in the [`Files`](https://github.com/jasonelle/jasonelle/tree/main/sources/xcode/App/Files) directory.


### [index.html](https://github.com/jasonelle/jasonelle/blob/main/sources/xcode/App/Files/index.html)

Is the example html file with code examples to test different _Jasonelle_ features.

### 3 - Allowed URLs

By default _Jasonelle_ will open all urls. If you wish to limit this behaviour you can use an `allowed` urls property in the configuration file.

Any url that is not present in the allowed list will force open using the native browser.

Check the [Configuration File](https://github.com/jasonelle/jasonelle/blob/main/sources/xcode/App/JS/config/dev.js)

![config file](https://user-images.githubusercontent.com/292738/218337885-a92fbeab-a210-4baa-9d75-e85aac6157cb.png)

#### Example

List the allowed urls.
Otherwise it will launch native browser
If not present will allow all urls

Put the same URL from main.js here to allow it (just the domain)

```js
allowed: ["file://", "google.cl"]
```


### 4 - Done

You can now configure your project as a normal XCode iOS. Change your App Icon and other settings.

Happy Coding!.

## ARM Processors (M1, M2...)

Ensure that you are running the `arm` binaries by appending `-arm` to the binaries names inside `build` file, as shown below.

Note: Since `3.0.2` this is automatically detected.

- ESBUILD=${SRCROOT}/../Tools/esbuild/esbuild-arm
- DPRINT=${SRCROOT}/../Tools/dprint/dprint-arm

![MacOS ARM](https://user-images.githubusercontent.com/292738/235188291-a198de0a-c508-4b58-a32a-c4b98209d62e.jpeg)

