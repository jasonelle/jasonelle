# ``JLShare``

Enables using [UIActivityViewController](https://developer.apple.com/documentation/uikit/uiactivityviewcontroller?language=objc).

## Overview

Useful if you want to share text, links and other content to other applications.

## Topics

### ``$share.text(value)``

- Since `3.0.2`

Will open share dialog with a text.


```js
const shareText = () => {
  $share.text("Hello World!");
};
``` 

### ``$share.url(value)``

- Since `3.0.2`

Will open share dialog with an url value. The url must be a valid url, otherwise
it will be interpreted as a text.

You can point to public files like images, pdf, audios and videos and they will be recognized as such and shared properly.

```js
const shareImage = () => {
    return $share.url("https://jasonelle.com/docs/jasonelle.png");
};
```

