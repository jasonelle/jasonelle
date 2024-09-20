# OneSignal Push Notifications

If you want push notifications with OneSignal
This version has been configured with `OneSignal 5.0` and Firebase `24`.

## build.gradle

Check `app/build.gradle` 
for the dependencies

```gradle
dependencies {
    // ...
    implementation 'com.google.firebase:firebase-messaging:24.0.0'
    implementation 'com.onesignal:OneSignal:[5.0.0, 5.99.99]'
}
```

## Launcher.java

The file `app/src/main/java/com/jasonette/seed/Launcher/Launcher.java`

You can configure the OneSignal setup here.

```java
// NOTE: Replace the below with your own ONESIGNAL_APP_ID
private static final String ONESIGNAL_APP_ID = "########-####-####-####-############";

private void setupOneSignal() {
    // Verbose Logging set to help debug issues, remove before releasing your app.
    OneSignal.getDebug().setLogLevel(LogLevel.VERBOSE);

    // OneSignal Initialization
    OneSignal.initWithContext(this, ONESIGNAL_APP_ID);

    // requestPermission will show the native Android notification permission prompt.
    // NOTE: It's recommended to use a OneSignal In-App Message to prompt instead.
    OneSignal.getNotifications().requestPermission(false, Continue.none());
}
```

## custom.js

The file `app/src/main/assets/file/custom.js` contains two helper functions
for your web app. You can call `$onesignal.login("email@example.com");` in your Javascript when you
need to map external_id to a device.

```js
$onesignal.login = (external_id) => {
  $agent.trigger("onesignal.login", {externalid: external_id});
};

$onesignal.logout = () => {
  $agent.trigger("onesignal.logout");
};
```

## hello.json

The example application can be used as this.
Needs to define two public actions that can call the internal `$onesignal` action.
With these the functions in _custom.js_ can work.

```json
{
  "$jason": {
    "head": {
      "actions": {
        "onesignal.login": {
          "type": "$onesignal.login",
          "options": {
            "externalid": "{{$jason.data.externalid}}"
          }
        },
        "onesignal.logout": {
          "type": "$onesignal.logout",
          "options": {}
        }
      }
    },
    "body": {
      "background": {
        "type": "html",
        "url": "https://jasonelle.com",
        "style": {
          "background": "#ffffff",
          "progress" : "rgba(0,0,0,0)"
        },
        "action": {
          "type": "$default"
        }
      }
    }
  }
}
```

## Additional Docs

- https://github.com/jasonelle-archive/jasonelle-v2/wiki/Push-notifications-integration-with-OneSignal
- https://documentation.onesignal.com/docs/aliases-external-id
- https://documentation.onesignal.com/docs/android-sdk-setup