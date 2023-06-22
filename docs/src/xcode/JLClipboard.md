# ``JLClipboard``

Handles native Clipboard actions

## Overview

Provides access to native clipboard

## Topics

### Actions

- ``$clipboard.set(text)``
- Since `3.0.2`

Copy text to the native clipboard.

```js
$clipboard.set("Hello")
```

- ``$clipboard.get()``
- Since `3.0.2`

Returns the current text in the native clipboard.

```js
$clipboard.get().then(text => alert(text));
```

