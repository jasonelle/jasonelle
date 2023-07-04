# ``JLToast``

Present different message `Toast` and banners that allow displaying quick information using native features.

## Overview

Useful if you want to present information to the user.

## Topics

### Loading Indicator

The loading indicator can show a task is executing and will block any other interaction until the task is ready.

#### ``$toast.loading.show``
- Since: `3.0.2`

It will show a loading indicator (will block any other interaction).

```js
$toast.loading.show();
```

#### ``$toast.loading.hide``
- Since: `3.0.2`

It will hide the loading indicator (if present).

```js
$toast.loading.hide();
```

### Toast

The toast is a small message that can appear from top, center or bottom of the screen for a few seconds.

#### ``$toast.show(text, options = {type, position, duration})``
- Since: `3.0.2`

It will show a text for a given duration (defaults 3 seconds).

```js
$toast.show("Hello!");
```

#### ``$toast.dark(text, options = {})``
- Since: `3.0.2`

It will show a text in dark background for a given duration (defaults 3 seconds).

```js
$toast.dark("Hello!");
```
#### ``$toast.error(text, options = {})``
- Since: `3.0.2`

It will show a text in red background for a given duration (defaults 3 seconds).

```js
$toast.error("Hello!");
```

#### ``$toast.success(text, options = {})``
- Since: `3.0.2`

It will show a text in green background for a given duration (defaults 3 seconds).

```js
$toast.success("Hello!");
```

#### ``$toast.warning(text, options = {})``
- Since: `3.0.2`

It will show a text in yellow background for a given duration (defaults 3 seconds).

```js
$toast.warning("Hello!");
```

#### ``$toast.info(text, options = {})``
- Since: `3.0.2`

It will show a text in white background for a given duration (defaults 3 seconds).

```js
$toast.info("Hello!");
```

### Banner

The banner is an element that always appears from the upper part. Similar to a _Push Notification_ UX.

#### ``$toast.banner.show(text, options = {type, duration})``
- Since: `3.0.2`

It will show a text for a given duration (defaults 3 seconds).

```js
$toast.banner.show("Hello!");
```

#### ``$toast.banner.dark(text, options = {})``
- Since: `3.0.2`

It will show a text in dark background for a given duration (defaults 3 seconds).

```js
$toast.dark("Hello!");
```
#### ``$toast.banner.error(text, options = {})``
- Since: `3.0.2`

It will show a text in red background for a given duration (defaults 3 seconds).

```js
$toast.error("Hello!");
```

#### ``$toast.banner.success(text, options = {})``
- Since: `3.0.2`

It will show a text in green background for a given duration (defaults 3 seconds).

```js
$toast.success("Hello!");
```

#### ``$toast.banner.warning(text, options = {})``
- Since: `3.0.2`

It will show a text in yellow background for a given duration (defaults 3 seconds).

```js
$toast.warning("Hello!");
```

#### ``$toast.banner.info(text, options = {})``
- Since: `3.0.2`

It will show a text in white background for a given duration (defaults 3 seconds).

```js
$toast.info("Hello!");
```
