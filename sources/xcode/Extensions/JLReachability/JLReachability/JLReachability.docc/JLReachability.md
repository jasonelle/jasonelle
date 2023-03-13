# ``JLReachability``

Helps to detect when access to internet was lost.

- Since: `3.0.1`

## Overview

Sends a notification event inside the _WebView_ and _NSNotificationCenter_.

## Topics

### Configuration

Be sure to add [**SystemConfiguration.framework**](https://developer.apple.com/documentation/systemconfiguration?language=objc) in _Bundle Without Signing mode_.

### Status

```js
const reachability = {
    // Apple NetworkStatus Compatible Names.
    status: {
        not_reachable: 0,
        wwan_reachable: 1,
        cellular_reachable: 1, // the same as wwan, just to have ubiquotus language
        wifi_reachable: 2
    },
    status_names: {
       0: "No Connection",
       1: "Cellular",
       2: "Wifi"
    }
};
```

### Actions

- ``$reachability.get``: Returns the current reachability object.

**Schema**

```js
{
    "status": Number, // Status of the Connection
    "reachable": Boolean, // true if is reachable
    "label": String // String with the current connection label
}
```

**Example**

```js
$reachability.get().then(result => alert(result.label));
```


### Events

- ``$reachability.events.changed``: Triggered when a change in reachability is detected.

**Example**

```js
document.addEventListener("$reachability.events.changed", function(e) {
    $logger.trace("Reachability Changed: " + JSON.stringify(e.detail));
});
```

### Notification

An [NSNotification](https://developer.apple.com/documentation/foundation/nsnotification) is sent with the name `kReachabilityChangedNotification`.

```objc
// Here we set up a NSNotification observer. The Reachability that caused the notification
// is passed in the object parameter
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(reachabilityChanged:)
                                             name:kReachabilityChangedNotification
                                           object:nil];
```

See more details at [Tony Million's Reachability Docs](https://github.com/tonymillion/Reachability).
