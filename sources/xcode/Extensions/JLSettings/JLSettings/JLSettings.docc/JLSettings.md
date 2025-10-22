# ``JLSettings``

Enables getting the settings inside `UIBundle.mainBundle.infoDictionary`


## Overview


## Example Usage

```js
$settings.get().then(values => {
    const version = values["CURRENT_PROJECT_VERSION"];         
    $toast.success("Build Version: " + version);
});
```
