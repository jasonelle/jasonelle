# ``JLATTrackingManager``

Optionally install [ATTracking Support](https://developer.apple.com/documentation/apptrackingtransparency)
Request user authorization to access app-related data for tracking the user or the device.
Ensure to configure the plist as well.
If your app calls the App Tracking Transparency API, you must provide custom text, known as a usage-description string, which displays as a system-permission alert request. The usage-description string tells the user why the app is requesting permission to use data for tracking the user or the device.

- Since: `3.0.1`

## Overview

Request user authorization to access app-related data for tracking the user or the device.


## Topics

### Installation

The _ATTracking_ message will be triggered on `install`.

#### info.plist

Configure your `info.plist` and include the [`NSUserTrackingUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsusertrackingusagedescription?language=objc) key and fill it with the description.

### Properties

#### status
Returns the current [status](https://developer.apple.com/documentation/apptrackingtransparency/attrackingmanagerauthorizationstatus?language=objc) for the ATTracking.

### Actions

#### ``$attracking.status()``

- Since `3.0.2`

Returns the current status.

```js
$attracking.status().then(result => {
    $logger.trace(result);
});
```
