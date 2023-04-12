//
//  JLAudioPlayer.m
//  JLAudio
//
//  Copyright (c) Jasonelle.com
//
//  This file is part of Jasonelle Project <https://jasonelle.com>.
//  Jasonelle Project is dual licensed. You can choose between AGPLv3 or MPLv2.
//  MPLv2 is only valid if the software has a unique Jasonelle Key which was purchased in official channels.
//
//  == AGPLv3
//  Jasonelle is free software: you can redistribute it and/or modify it under the terms of the Affero GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
//  Jasonelle is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the Affero GNU General Public License for more details.
//  You should have received a copy of the Affero GNU General Public License along with Jasonelle. If not, see <https://www.gnu.org/licenses/>.
//
//  == MPLv2 (Only valid if purchased a Jasonelle Key)
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  <https://mozilla.org/MPL/2.0/>.
//

#import "JLAudioPlayer.h"

@implementation JLAudioPlayer

- (instancetype)initWithApplication:(JLApplication *)app {
    self = [super init];
    if (self) {
        self.app = app;
        self.logger = app.logger;
    }

    return self;
}

- (AVPlayer *) newPlayer {
    return [[AVPlayer alloc] initWithPlayerItem:nil];
}

- (AVPlayer *) playerAtChannel: (int) channel {
    return self.channels[@(channel)];
}

- (AVPlayer *) pauseChannel: (int) channel {
    AVPlayer * player = [self playerAtChannel:channel];
    [player pause];
    return player;
}

- (AVPlayer *) playChannel: (int) channel withOptions: (JLJSParams *) options {
    AVPlayer * player = [self playerAtChannel:channel];
    [self setOptions:[self
                      options:options
                      forPlayer:player
                      inChannel:channel]
           forPlayer:player];
    [player play];
    return player;
}

- (AVPlayer *) setOptions: (NSDictionary *) options forPlayer: (AVPlayer *) player {
    
    float volume = [options[@"volume"] floatValue];
    [player setVolume:volume];
    
    return player;
}

- (NSDictionary *) channels {
    if (!_channels) {
        _channels = @{
            @0: [self newPlayer],
            @1: [self newPlayer],
            @2: [self newPlayer],
            @3: [self newPlayer],
            @4: [self newPlayer],
            @5: [self newPlayer],
            @6: [self newPlayer],
            @7: [self newPlayer],
            @8: [self newPlayer],
            @9: [self newPlayer],
            @10: [self newPlayer],
            @11: [self newPlayer],
            @12: [self newPlayer],
            @13: [self newPlayer],
            @14: [self newPlayer],
            @15: [self newPlayer],
            @16: [self newPlayer],
        };
    }
    return _channels;
}

- (NSDictionary *) options: (JLJSParams *) options
                 forPlayer: (AVPlayer *) player
                 inChannel: (int) channel {
    
    NSNumber * volume = [options number:@"volume" default:@(player.volume)];
    NSNumber * channelOpt = [options number:@"channel" default:@(channel)];
    
    NSMutableDictionary * playOpts = [@{
        @"volume": @(player.volume),
        @"channel": @(channel)
    } mutableCopy];
    
    if ([volume floatValue] >= 0) {
        playOpts[@"volume"] = volume;
    }
    
    int chan = [channelOpt intValue];
    
    // TODO: Make channels api
    if (chan >= 0 && chan <= 16) {
        playOpts[@"channel"] = channelOpt;
    }
    
    return [playOpts copy];
}

- (void) vibrateWithOptions: (JLJSParams *) options {
    // AudioServicesPlaySystemSound (1352) works for iPhones regardless of silent switch position
    int vibrationId = 1352; // kSystemSoundID_Vibrate;
    AudioServicesPlayAlertSoundWithCompletion(vibrationId, ^{
        jlog_trace_join(@"Vibrated with sound id: ", @(vibrationId));
    });
}

- (AVPlayer *) loadURL: (NSURL *) url withOptions: (JLJSParams *) options {
    
    jlog_trace_join(@"Loading File At URL: ", url, @" with options: ", options.description);
    
    int channel = [[options number:@"channel" default:@0] intValue];
    
    AVPlayer * player = [self playerAtChannel:channel];
    
    [self setOptions:[self
                      options:options forPlayer:player inChannel:channel]
           forPlayer:player];
    
    // TODO: Maybe allow cache or similar to the file if they are from internet
    AVPlayerItem * item = [[AVPlayerItem alloc] initWithURL:url];
    
    // Know if there was an error loading. Just to log the message
    [item addObserver:self
           forKeyPath:@"status"
              options:NSKeyValueObservingOptionNew
              context:nil];
    
    [player replaceCurrentItemWithPlayerItem:item];
    
    return player;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    if(![keyPath isEqualToString:@"status"]) {
        return;
    }
    
    AVPlayerItem * item = (AVPlayerItem *) object;
    
    if (item.status == AVPlayerStatusReadyToPlay) {
        jlog_trace_join(@"Audio is ready to play");
    } else {
        jlog_warning_join(@"Audio was not loaded. Check if URL is reachable by the App.");
        jlog_trace(item.error.description);
        jlog_trace(item.errorLog.description);
    }
    
    [item removeObserver:self forKeyPath:@"status"];
}

@end
