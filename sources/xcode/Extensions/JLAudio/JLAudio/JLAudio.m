//
//  JLAudio.m
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

#import "JLAudio.h"

// Player
#import "JLAudioPlayMessageHandler.h"
#import "JLAudioPauseMessageHandler.h"
#import "JLAudioLoadMessageHandler.h"
#import "JLAudioVibrateMessageHandler.h"


// Recorder
#import "JLAudioRecorderAuthorizeMessageHandler.h"
#import "JLAudioRecorderStopMessageHandler.h"
#import "JLAudioRecorderPauseMessageHandler.h"
#import "JLAudioRecorderResumeMessageHandler.h"
#import "JLAudioRecorderStartMessageHandler.h"

@implementation JLAudio

- (JLAudioPlayer *) player {
    if(!_player) {
        _player = [[JLAudioPlayer alloc] initWithApplication:self.app];
    }
    
    return _player;
}

- (JLAudioRecorder *) recorder {
    if (!_recorder) {
        _recorder = [[JLAudioRecorder alloc] initWithApplication:self.app andExtension:self];
    }
    return _recorder;
}

- (AVAudioSession *) session {
    if (!_session) {
        NSError * error;
        _session = [AVAudioSession sharedInstance];
        
        [_session
         setCategory:AVAudioSessionCategoryPlayAndRecord
         mode:AVAudioSessionModeDefault
         options:AVAudioSessionCategoryOptionMixWithOthers
         error:&error];
        
        if (error) {
            jlog_warning_join(@"Error initializing AVAudioSession: ", error.description);
        }
    }
    
    return _session;
}

#pragma mark Extension Methods

- (void) install {
    [super install];
    [self session];
    
    JLAudioPlayMessageHandler * playHandler = [[JLAudioPlayMessageHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLAudioPauseMessageHandler * pauseHandler = [[JLAudioPauseMessageHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLAudioLoadMessageHandler * loadHandler = [[JLAudioLoadMessageHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLAudioVibrateMessageHandler * vibrateHandler = [[JLAudioVibrateMessageHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLAudioRecorderAuthorizeMessageHandler * authorizeHandler = [[JLAudioRecorderAuthorizeMessageHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLAudioRecorderStartMessageHandler * startHandler = [[JLAudioRecorderStartMessageHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLAudioRecorderPauseMessageHandler * recorderPauseHandler = [[JLAudioRecorderPauseMessageHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLAudioRecorderStopMessageHandler * stopHandler = [[JLAudioRecorderStopMessageHandler alloc] initWithApplication:self.app andExtension:self];
    
    JLAudioRecorderResumeMessageHandler * resumeHandler = [[JLAudioRecorderResumeMessageHandler alloc] initWithApplication:self.app andExtension:self];
    
    self.handlers = @{
        @"$audio.player.play": playHandler,
        @"$audio.player.pause": pauseHandler,
        @"$audio.player.load": loadHandler,
        
        @"$audio.vibrate": vibrateHandler,
        
        @"$audio.recorder.authorize": authorizeHandler,
        @"$audio.recorder.record": startHandler,
        @"$audio.recorder.pause": recorderPauseHandler,
        @"$audio.recorder.stop": stopHandler,
        @"$audio.recorder.resume": resumeHandler
    };
}

#pragma mark - Inject JS
- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    // Install the wrappers inside the webview
    return [self injectJS];
}

@end
