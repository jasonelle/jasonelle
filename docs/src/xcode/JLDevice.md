# ``JLDevice``

Enables access to device's info.

## Overview

Provides access to the current device model, size, system and vendor identifiers.

## Topics

### Actions

- ``$device.info()``

- Since: `3.0.2`

Returns an object with current device info.

**Example**

```js
const deviceInfo = () => $device.info().then(info => {
    $logger.trace(info);
    alert(info.env.hw.name);
});
```

```text
{
    env =     {
        hw =         {
            id = 0;
            name = simulator;
        };
        type =         {
            id = 1;
            name = develop;
        };
    };
    license =     {
        enabled = 1;
    };
    process =     {
        device =         {
            model =             {
                localized = iPhone;
                name = iPhone;
            };
            name = "iPhone SE (2nd generation)";
            orientation =             {
                id = 1;
                portrait = 1;
            };
            size =             {
                height = 667;
                width = 375;
            };
            system =             {
                name = iOS;
                simulator = 1;
                version = "14.0.1";
            };
        };
        identifiers =         {
            vendor = "32DD46B4-323B-4396-B3CA-BE232104423";
        };
    };
}
```
