## Adding an Extension

Extensions are a single _*.xcodeproj_ (blue icon)
that contains the project that can be added to the 
_App.xcworkspace_ (white icon) file.

### Step 1

Open _App.xcworkspace_ with _Xcode_ and
look for the _*.xcodeproj_ file in _Finder_.

![xcodeproj](https://user-images.githubusercontent.com/292738/219871592-c9f788d9-82b9-436e-b498-ec8c9de57d77.png)

### Step 2
Draw it to the _Extensions_ directory inside _Xcode_.

![extensions.1](https://user-images.githubusercontent.com/292738/219871792-a2e6b3ab-76ac-4140-9b83-afaa166a3c2b.png)


![extensions.2](https://user-images.githubusercontent.com/292738/219871905-4a884db2-58d7-45a1-aedd-8ab9a22f5ce2.png)

### Step 3

Add it to the frameworks in _App.xcproj_ file.
Be sure that **Embed & Sign** option is selected.

![added frameworks](https://user-images.githubusercontent.com/292738/219872025-bfa926e7-907e-4277-97e7-b96602889857.png)

### Step 4

import the extension in **AppExtensions.m**.

![add.extensions](https://user-images.githubusercontent.com/292738/219872338-01e31f1e-3f16-4914-bf73-5b75f2ccd167.png)

and add it to the extension registry in `install` method
using the `class` attribute.

Example: `[self.extensions add: JLContacts.class];`

![install.extensions](https://user-images.githubusercontent.com/292738/219872570-6e09e504-8ec2-4dec-bd53-27cd69f7800e.png)

### Done

If everything is ok then the extension was installed successfully, 
maybe some other configurations would be needed depending on the extension itself.
