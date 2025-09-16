# ``JLSettings``

This is a special extension project to store global settings like SDK keys
and other common configuration variables. 
It works by executing a python script that reads a json file, then generates a
`JLSettings.h` file than can be imported in any extension or the main app. 
This python script is automatically executed in every build.

## Overview

The extension consists of a json file and a python file.
The python file would read the json file and generate the
`JLSettings.h` file that can be included in the project
and shared in both extensions and app.

This framework is meant to be imported in any extension
that requires configuration keys. For example _OneSignal_ push notifications
or similar. A single json file can be shared between _iOS_ and _Android_
and generate the settings needed.


## Example Usage

```objc
jlog_trace_join(@"JLSettings: ", @(JLSettingExampleAPIKey));
// com.jasonelle: [TRACE] JLSettings: JLSetting Example Value | file: AppExtensions.m | function: -[AppExtensions install] | line: 64
```

Also in can be added in a global `self.app.settings.values` property that contains a dictionary of values. This property is installed when loading the extension inside AppDelegate.

```objc
#import <JLSettings/JLSettings.h>
...
[self.extensions add:JLSettings.class];
```

```objc
// JLSettings.m
[self.app setGlobalSettings:@{
    @"com.jasonelle.settings.example": @(JLSettingExampleAPIKey)
}];

// Access values within the app databag
jl_trace(self.app.settings.values);
```
