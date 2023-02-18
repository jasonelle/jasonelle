## Removing an Extension

If you don't need an extension you can remove it from the workspace.

### Step 1

Remove (or comment) the setup code in `AppExtensions.m` file
described in `Adding an Extension: Step 4`.

![install.extensions](https://user-images.githubusercontent.com/292738/219872570-6e09e504-8ec2-4dec-bd53-27cd69f7800e.png)

![add.extensions](https://user-images.githubusercontent.com/292738/219872338-01e31f1e-3f16-4914-bf73-5b75f2ccd167.png)

### Step 2

Remove the `framework` from the _App.xcproj_ file.

![added frameworks](https://user-images.githubusercontent.com/292738/219872025-bfa926e7-907e-4277-97e7-b96602889857.png)

### Step 3

Delete the `*.xcodeproj` file from the Workspace.
It will pop up a confirmation dialog. We recommend `Remove Reference` option.

![remove reference](https://user-images.githubusercontent.com/292738/219873278-f4b6f7a2-e644-48d8-94e9-7702fb09935c.png)
