# ``JLPluginAppleSignIn``

A Jasonelle plugin that integrates Sign in with Apple into hybrid web applications using Apple's AuthenticationServices framework and Human Interface Guidelines.

## Overview

`JLPluginAppleSignIn` provides a bridge between web JavaScript and Apple's native `AuthenticationServices` framework (`ASAuthorizationController`, `ASAuthorizationAppleIDProvider`, and `ASAuthorizationAppleIDButton`).

It allows hybrid web applications running inside Jasonelle to:
1. Render official, accessible "Sign in with Apple" buttons adhering to Apple's Human Interface Guidelines (HIG).
2. Initiate native Apple ID authorization flows requesting scopes such as `fullName` and `email`.
3. Query credential states for stored Apple user identifiers (`authorized`, `revoked`, `notFound`, `transferred`).
4. Display a native UIKit `ASAuthorizationAppleIDButton` overlay when native presentation is preferred.

### Structure

| File | Role |
|------|------|
| `Plugin.swift` | Native iOS side – bridges to `AuthenticationServices` (`ASAuthorizationController`, `ASAuthorizationAppleIDProvider`). |
| `Plugin.js` | JavaScript side – registers on `window.jasonelle.plugins.applesignin`, provides the Button Controller and HIG renderer. |

### How It Works

1. The plugin is injected into the webview at document end and registers itself on `window.jasonelle.plugins.applesignin`.
2. Calling `plugin.signIn(options)` or tapping an authentic button created with `plugin.createButton(options)` or `plugin.renderButton(target, options)` triggers the native `ASAuthorizationController` sheet.
3. Upon user authorization with Face ID, Touch ID, or passcode, the native handler receives the `ASAuthorizationAppleIDCredential` and resolves the promise with the user identifier, authorization code, and identity token JWT.
4. If the user cancels or an error occurs, the promise rejects with standard error codes (e.g. `code: 1001, canceled: true`).

### JavaScript Usage

#### 1. Rendering an Apple HIG Button in HTML

```javascript
// Render a standard black button
window.jasonelle.plugins.applesignin.renderButton("#auth-container", {
  type: "signIn", // "signIn" | "continue" | "signUp" | "logoOnly"
  style: "black",  // "black" | "white" | "white-outline"
  borderRadius: 8,
  height: 44,
  scopes: ["fullName", "email"],
  onSuccess: (credential) => {
    console.log("Logged in user:", credential.user);
    console.log("Identity token (JWT):", credential.identityToken);
  },
  onError: (error) => {
    if (error.canceled) {
      console.log("User canceled sign in");
    } else {
      console.error("Sign in failed:", error);
    }
  }
});
```

#### 2. Triggering Programmatic Sign In

```javascript
try {
  const credential = await window.jasonelle.plugins.applesignin.signIn({
    scopes: ["fullName", "email"],
    nonce: "crypto-nonce-string"
  });

  console.log("User identifier:", credential.user);
  console.log("Email:", credential.email);
  console.log("Full Name:", credential.fullName?.formatted);
} catch (error) {
  console.error("Sign in error:", error);
}
```

#### 3. Checking Credential State

```javascript
const result = await window.jasonelle.plugins.applesignin.getCredentialState(userId);
if (result.state === "authorized") {
  // User is still logged in
} else {
  // Credential was revoked or transferred
}
```

### Response Format

On successful sign-in, the returned object contains:

```json
{
  "status": "ok",
  "user": "001234.a76b9f...",
  "email": "user@example.com",
  "fullName": {
    "givenName": "Jane",
    "familyName": "Appleseed",
    "formatted": "Jane Appleseed"
  },
  "identityToken": "eyJhbGciOi...",
  "authorizationCode": "c6204...",
  "realUserStatus": "likelyReal",
  "authorizedScopes": ["email", "fullName"]
}
```

## Topics

### Essentials

- ``JLPluginAppleSignIn/Plugin``
