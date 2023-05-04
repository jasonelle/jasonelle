# ``JLPhotoLibrary``

Provides methods to requesting [Photo Library](https://developer.apple.com/documentation/photokit/phphotolibrary) and [Camera](https://developer.apple.com/documentation/avfoundation/capture_setup/requesting_authorization_to_capture_and_save_media?language=objc) permissions 

- Since: `3.0.1`

## Overview

It would be required if your app wants to access camera or photo library.

## Topics

### Actions

#### ``$photolibrary.granted()``

- Since `3.0.1`

Returns `Promise.resolve(Bool)` if the permission is granted.

**Example**

```js
$photolibrary.granted().then(granted => alert(granted));
```

#### ``$photolibrary.authorize(showAlert = true)``

- Since `3.0.1`

Returns `Promise.resolve(Int)` with the Authorization Status.

If `showAlert = true` then it will prompt an alert requesting the user go _Settings_.

The returned number corresponds to [`PHAuthorizationStatus`](https://developer.apple.com/documentation/photokit/phauthorizationstatus)

By default will request access to all photos.

**Example**

```js
$photolibrary.authorize().then(status => $logger.trace(status));
```

#### ``$photolibrary.camera.granted()``

- Since `3.0.2`

Returns `Promise.resolve(Bool)` if the camera permission is granted.

**Example**

```js
$photolibrary.granted().then(granted => alert(granted));
```

#### ``$photolibrary.camera.authorize(showAlert = true)``

- Since `3.0.2`

Returns `Promise.resolve(Int)` with the Camera authorization status.

If `showAlert = true` then it will prompt an alert requesting the user go _Settings_.

The returned number corresponds to [`AVAuthorizationStatus`](https://developer.apple.com/documentation/avfoundation/avauthorizationstatus?language=objc)

**Example**

```js
$photolibrary.camera.authorize().then(status => $logger.trace(status));
```

### ``info.plist``

Add the following permissions to `info.plist`:

- [NSPhotoLibraryUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nsphotolibraryusagedescription)
- [NSCameraUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nscamerausagedescription)

- [PHPhotoLibraryPreventAutomaticLimitedAccessAlert](https://developer.apple.com/documentation/photokit/phphotolibrary?language=objc) Set to `YES`.

- [NSPhotoLibraryAddUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nsphotolibraryaddusagedescription?language=objc) Description.

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>If you want to use the photolibrary, you have to give permission.</string>
<key>NSCameraUsageDescription</key>
<string>If you want to use the camera, you have to give permission.</string>
```
