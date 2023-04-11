# ``JLAudio``

A simple wrapper to record and play audio files using the native device apis.

- Since: `3.0.2`

## Overview

This interacts directly with [`AVPlayer`](https://developer.apple.com/documentation/avfoundation/avplayer?language=objc).

The current player support up to 16 channels. With channel 0 as the default.
You can individually play each channel and set options such as volume.

## Topics

### Audio Player Actions

#### ``$audio.player.load(url, options = {})``

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
