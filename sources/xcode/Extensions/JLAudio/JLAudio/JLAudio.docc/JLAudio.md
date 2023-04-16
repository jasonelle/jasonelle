# ``JLAudio``

A simple wrapper to record and play audio files using the native device apis.

- Since: `3.0.2`

## Overview

## Topics

### Vibration

#### `$audio.vibrate()`

- Since `3.0.2`

Sends the vibration alarm sound. Works for iPhones regardless of silent switch position.

### Audio Player Actions

This interacts directly with [`AVPlayer`](https://developer.apple.com/documentation/avfoundation/avplayer?language=objc).

The current player support up to 16 channels. With channel 0 as the default.
You can individually play each channel and set options such as volume.

#### ``$audio.player.load(url, options = {channel = 0, volume = 1})``

- Since: `3.0.2`

Loads an audio file from a remote url. 

#### ``$audio.player.play(channel = 0, options = {})``

- Since: `3.0.2`

Plays the audio file at the given channel with options.
Defaults to channel `0`.

#### ``$audio.player.pause(channel = 0, options = {})``

- Since: `3.0.2`

Pauses the audio file playing at given channel with options.
Defaults to channel `0`.

### Audio Recording Actions

#### ``$audio.recorder.authorize()``

- Since `3.0.2`

Authorizes audio recording capabilities. Must set [`NSMicrophoneUsageDescription`](https://developer.apple.com/documentation/bundleresources/information_property_list/nsmicrophoneusagedescription) in `info.plist`.

Returns a `Promise`. Rejects it if access was not granted.

**Example**

```js
$audio.recorder.authorize().then(granted => $logger.trace(`Audio Recording is granted?: ${granted}`))
   .catch(message => $logger.trace("Audio Recording Authorization Not Granted"));
```

#### ``$audio.recorder.record()``

- Since `3.0.2`

Starts recording. Triggers `$audio.recorder.status.event` every `0.5` seconds.

#### ``$audio.recorder.stop()``

- Since `3.0.2`

Stops the current recording. Triggers `$audio.recorder.finished.event`.

#### ``$audio.recorder.pause()``

- Since `3.0.2`

Pauses/Resumes the current recording.

#### Events

##### ``$audio.recorder.status.event``

- Since `3.0.2`

Returns the current status for the recording and additional information.

**event.detail**

```objc
{
    "file": {
        "url": self.file.absoluteString,
        "url_components": self.file.pathComponents
    },
    "state": self.state,
    "settings": self.settings,
    "time": {
        "audio": {
            "formatted": [self timeStringForTimeInterval:self.recorder.currentTime],
            "current": self.recorder.currentTime,
        },
        "device": {
            "formatted": [self timeStringForTimeInterval:self.recorder.deviceCurrentTime],
            "current": self.recorder.deviceCurrentTime
        }
    },
}
```

##### ``$audio.recorder.finished.event``

- Since `3.0.2`

The recording ended and returns the information for the file.
Audio data is encoded in a `Base64` string so it can be easily send via http requests.

**event.detail**

```objc
{
    "status": self.currentStatus,
    "file": {
        "url": self.file.absoluteString,
        "url_components": self.file.pathComponents,
        "data": self.base64Data,
        "uri": self.base64DataURI,
        "content_type": self.contentType,
        "time": {
            "formatted": self.duration,
            "total": self.seconds,
        }
    }
    
}
```

##### ``$audio.recorder.error.event``

- Since `3.0.2`

Returns some information if there was an error recording. 

**event.detail**

```objc
{
   "message": error.localizedDescription,
   "code": error.code,
   "info": error.userInfo,
   "file": {
        "url": self.file.absoluteString,
        "url_components": self.file.pathComponents
    }
}
```
