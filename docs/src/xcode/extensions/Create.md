## Create Extensions

Creating extensions requires some knowledge of `Objective-C` and `JavaScript`. These instructions are for advanced users.

### Step 1

Create a new _xcodeproj_ file.

![new](https://user-images.githubusercontent.com/292738/219874044-bab47dc0-3d62-4e7a-b56c-73f5e9ad3e28.png)

Select `Framework` as the template. Be sure that is in the _iOS_ tab.

![framework](https://user-images.githubusercontent.com/292738/219874161-503cacaf-ae52-4328-bfdd-0fb856e9a4cb.png)

Add it to the _Extensions_ directory inside the _App.xcworkspace_.

![ext.1](https://user-images.githubusercontent.com/292738/219874367-b104a4d3-7cc7-4f20-85ab-56274d19e694.png)

![ext.2](https://user-images.githubusercontent.com/292738/219874405-f35b1b56-7703-46b3-8083-ce1408b49d5b.png)


### Step 2

Configure the _iOS Deployment Target_ to `14.0` (or the recommended version for your project).

![d.target](https://user-images.githubusercontent.com/292738/219875281-2b219bee-3d8b-4c52-a21d-b4fd179a438e.png)


Add the `JLKernel` framework. Select **Do Not Embed** as the option. Since all the frameworks will be embeded in `App.xcproj` later.

![d.kernel](https://user-images.githubusercontent.com/292738/219875346-48555ad5-459c-4f0c-b104-69c702f3e3f1.png)


### Step 3

Create the `*.h` and `*.m` files that inherits from _JLExtension_.

![dialog.create.1](https://user-images.githubusercontent.com/292738/219875533-f3e6bf76-9010-43c3-b244-daf2b3fd7fc5.png)

![dialog.create.2](https://user-images.githubusercontent.com/292738/219875521-aae7a10d-4341-4a1a-b406-6c840fc6cf92.png)

![dialog.create.3](https://user-images.githubusercontent.com/292738/219875586-f48a183b-bb76-4768-9ee0-08b1755ce417.png)

#### Example

**MyExtension.h**

```objective-c

#import <Foundation/Foundation.h>

//! Project version number for MyExtension.
FOUNDATION_EXPORT double MyExtensionVersionNumber;

//! Project version string for MyExtension.
FOUNDATION_EXPORT const unsigned char MyExtensionVersionString[];

#import <JLKernel/JLKernel.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyExtension : JLExtension
@end

NS_ASSUME_NONNULL_END
```

**MyExtension.m**

```objective-c
#import "MyExtension.h"

@implementation MyExtension

@end
```

### Done

Now you can install it as any other extension in your _App.xcodeproj_ file.
