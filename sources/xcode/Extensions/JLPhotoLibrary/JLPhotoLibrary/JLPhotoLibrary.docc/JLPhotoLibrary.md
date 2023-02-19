# ``JLPhotoLibrary``

Provides methods to requesting [Photo Library](https://developer.apple.com/documentation/photokit/phphotolibrary) permissions

## Overview

It would be required if your app wants to access camera or photo library.
Will trigger only in `install` event. Does not have webview actions yet.

## Topics

### info.plist

Add [NSPhotoLibraryUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nsphotolibraryusagedescription) and [NSCameraUsageDescription](https://developer.apple.com/documentation/bundleresources/information_property_list/nscamerausagedescription) permissions to info.plist

```xml
<key>NSPhotoLibraryUsageDescription</key>
<string>If you want to use the photolibrary, you have to give permission.</string>
<key>NSCameraUsageDescription</key>
<string>If you want to use the camera, you have to give permission.</string>
```
