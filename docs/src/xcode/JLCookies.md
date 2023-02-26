# ``JLCookies``

A helper to work with the `WebView` cookies.

- Since: `3.0.1`

## Overview

Requires [`$keychain`](JLKeychain.html) extension.

## Topics

### Actions

- ``$cookies.set``: Stores document.cookie in keychain.
- ``$cookies.get``: Gets cookie value stored in keychain.
- ``$cookies.remove``: Removes cookies value from keychain.
- ``$cookies.write``: Gets the cookie value stored in keychain and write it to document.cookie.
- ``$cookies.Cookies``: [js-cookie](https://github.com/js-cookie/js-cookie) Helper.

### Examples

**Sets the cookie and save it to keychain**

```js
// Set a value inside document.cookies
$cookies.Cookies.set('name', 'Ethan'); 

// Save the document.cookies to keychain.
$cookies.set().then(val => alert(val));
```

**Gets the current cookie value from keychain**

```js
$cookies.get().then(val => alert(val));
```

**Reads cookie from keychain and then writes to document.cookie**

```js
$cookies.write().then(val => alert(val));
```

**Removes cookies from keychain**

```js
$cookies.Cookies.remove('name'); 
$cookies.remove().then(val => alert(val));
```
