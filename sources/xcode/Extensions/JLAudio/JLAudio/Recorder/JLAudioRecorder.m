//
//  JLAudioRecorder.m
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

#import "JLAudioRecorder.h"
#import "JLAudio.h"

static const float DEFAULT_SAMPLE_RATE = 44100.0f;
static const int DEFAULT_CHANNELS = 1;
static const int DEFAULT_BIT_RATE = 0;
static const int DEFAULT_MAX_DURATION = 0;
static const int DEFAULT_QUALITY = AVAudioQualityMax;
NSString * const DEFAULT_FORMAT = @"m4a";

NSString * const kJLAudioRecorderStatusEvent = @"window.$audio.events.recorder.status.dispatch";

NSString * const kJLAudioRecorderDidFinishEvent = @"window.$audio.events.recorder.finished.dispatch";

NSString * const kJLAudioRecorderDidErrorEvent = @"window.$audio.events.recorder.error.dispatch";

@implementation JLAudioRecorder

#pragma mark - Init methods

- (instancetype)initWithApplication:(JLApplication *)app andExtension:(nonnull JLExtension *)extension {
    self = [super init];
    if (self) {
        self.app = app;
        self.logger = app.logger;
        self.extension = extension;
    }

    return self;
}

- (NSURL *) file {
    if (!_file) {
        _file = [self.app.utils.fs
                 fileURLForPath:[self.app.utils.fs     
                                 tempFilePathWithExtension:DEFAULT_FORMAT]];
    }
    return _file;
}

- (JLAudio *) ext {
    return (JLAudio *) self.extension;
}

- (JLAudioState) state {
    if (!_state) {
        _state = JLAudioStateNone;
    }
    return _state;
}

#pragma mark Helper Methods
- (BOOL) presentAlertWhenNotAuthorizedWithCompletionHandler:(void (^)(BOOL granted))completionHandler {
    
    jlog_trace(@"Audio Recording Access Not Authorized");

    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Audio Recording Access", @"JLAudioRecordingAlertTitle. Alert title when Audio Recording Access is Denied") message:NSLocalizedString(@"This app requires access to your Microphone.", @"JLAudioRecordingAlertMessage. Alert message when Audio Recording Access is Denied") preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        jlog_trace(@"Canceled Audio Recording Authorization Alert.");
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", @"Go to Settings Button") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.app.utils openSettings];
    }]];

    [self.app.utils present:alert completion:^{
        jlog_trace(@"Presented Audio Recording Not Authorized Alert.");
        completionHandler(NO);
    }];
    
    return self.isRecordPermissionGranted;
}

- (BOOL) authorizeWithCompletionHandler:(void (^)(BOOL granted))completionHandler showAlert:(BOOL)showAlert {
    
    [self.ext.session requestRecordPermission:^(BOOL granted) {
        if (!self.ext.webview) {
            return;
        }
        
        self.isRecordPermissionGranted = granted;
        
        if (!granted && showAlert) {
            [self presentAlertWhenNotAuthorizedWithCompletionHandler:completionHandler];
            return;
        }
        
        completionHandler(granted);
    }];
    
    return self.isRecordPermissionGranted;
}

- (NSDictionary *) recordSettingsForOptions: (JLJSParams *) options {
    
    [self setSettingsWithOptions:options];
    
    return @{
        AVFormatIDKey: @(kAudioFormatMPEG4AAC),
        AVSampleRateKey: @(DEFAULT_SAMPLE_RATE),
        AVNumberOfChannelsKey: @(DEFAULT_CHANNELS),
        AVEncoderAudioQualityKey: @(DEFAULT_QUALITY),
        AVEncoderBitRateKey: @(DEFAULT_BIT_RATE)
    };
}

- (NSDictionary *) settings {
    if (!_settings) {
        _settings = @{
            @"format": DEFAULT_FORMAT,
            @"samplerate": @(DEFAULT_SAMPLE_RATE),
            @"channels": @(DEFAULT_CHANNELS),
            @"quality": @(DEFAULT_QUALITY),
            @"bitrate": @(DEFAULT_BIT_RATE)
        };
    }
    return _settings;
}

- (void) setSettingsWithOptions: (JLJSParams *) options {
    self.settings = @{
        @"format": DEFAULT_FORMAT,
        @"samplerate": @(DEFAULT_SAMPLE_RATE),
        @"channels": @(DEFAULT_CHANNELS),
        @"quality": @(DEFAULT_QUALITY),
        @"bitrate": @(DEFAULT_BIT_RATE)
    };
}

- (NSString *) timeStringForTimeInterval:(NSTimeInterval) timeInterval
{
    int secondsInMinute = 60;
    int secondsInHour = 3600;
    
    NSInteger ti = (NSInteger) timeInterval;
    NSInteger seconds = ti % secondsInMinute;
    NSInteger minutes = (ti / secondsInMinute) % secondsInMinute;
    NSInteger hours = (ti / secondsInHour);
    
    if (hours > 0) {
        return [NSString stringWithFormat:@"%02li:%02li:%02li", (long)hours, (long)minutes, (long)seconds];
    }
    
    return  [NSString stringWithFormat:@"%02li:%02li", (long)minutes, (long)seconds];
}

- (NSString *) stateStringForState: (JLAudioState) state {
    switch (state) {
        case JLAudioStateIdle:
            return @"idle";
            break;
        case JLAudioStatePaused:
            return @"paused";
            break;
        case JLAudioStateRecording:
            return @"recording";
            break;
        case JLAudioStateNone:
            return @"none";
            break;
        default:
            return @"unknown";
            break;
    }
}

- (NSDictionary *) currentStatus {
    return @{
        @"file": @{
            @"url": self.file.absoluteString,
            @"url_components": self.file.pathComponents
        },
        @"state": [self stateStringForState:self.state],
        @"settings": self.settings,
        @"time": @{
            @"audio": @{
                @"formatted": [self timeStringForTimeInterval:self.recorder.currentTime],
                @"current": @(self.recorder.currentTime),
            },
            @"device": @{
                @"formatted": [self timeStringForTimeInterval:self.recorder.deviceCurrentTime],
                @"current": @(self.recorder.deviceCurrentTime)
            }
        },
    };
}

- (void) sendStatusEventWithTimer: (NSTimer *) timer {
    
    [self.recorder updateMeters];
    
    NSDictionary * status = [self currentStatus];
    
    jlog_trace_join(status.description);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.app.utils.webview
         dispatch:kJLAudioRecorderStatusEvent
         arguments:status
         inWebView:self.ext.webview];
    });
}

- (void) setIdleTimerDisabled: (BOOL) disabled {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] setIdleTimerDisabled:disabled];
    });
}

- (void) disableIdleTimer {
    [self setIdleTimerDisabled:YES];
}

- (void) enableIdleTimer {
    [self setIdleTimerDisabled:NO];
}

- (void) startDurationTimer {
    [self stopDurationTimer];
    
    self.timer = [NSTimer
                  scheduledTimerWithTimeInterval:0.5f
                  target:self
                  selector:@selector(sendStatusEventWithTimer:)
                  userInfo:nil
                  repeats:YES];
}

- (void) stopDurationTimer {
    if(self.timer) {
        [self.timer invalidate];
    }
}

- (void) stop {
    jlog_trace(@"Stop Recording");
    self.state = JLAudioStateIdle;
    
    [self enableIdleTimer];
    [self stopDurationTimer];
    
    if (self.recorder) {
        [self.recorder stop];
    }
}

- (void) pause {
    
    // Resume if is already paused
    if (self.state != JLAudioStateRecording) {
        if (self.state == JLAudioStatePaused) {
            return [self resume];
        }
        jlog_trace(@"Audio is not recording");
        return;
    }
    
    jlog_trace(@"Pause Recording");
    
    self.state = JLAudioStatePaused;
    
    [self stopDurationTimer];
    
    if (self.recorder) {
        [self.recorder pause];
    }
}

- (void) resume {
    if (self.state != JLAudioStatePaused) {
        jlog_trace(@"Cannot Resume Recording. Please Use $audio.recorder.record");
        return;
    }
    
    jlog_trace(@"Continue Recording");
    [self recordForDuration:self.duration];
}

- (void) recordForDuration: (NSTimeInterval) duration {
    jlog_trace(@"Start Recording");
    self.state = JLAudioStateRecording;
    self.duration = (duration >= 0) ? duration : DEFAULT_MAX_DURATION;
    [self disableIdleTimer];
    [self startDurationTimer];
    [self.recorder recordForDuration:self.duration];
}

- (NSURL *) createNewTempFile {
    // Creates a new temp file and removes the old one
    [self.app.utils.fs removeFileAtPath:self.file.path];
    self.file = nil;
    return self.file;
}

- (void) recordWithOptions: (JLJSParams *) options {
    [self authorizeWithCompletionHandler:^(BOOL granted) {
        if (!granted) {
            return;
        }
        
        NSError * error;
        [self.ext.session setActive:YES error:&error];
        
        if (error) {
            jlog_warning_join(@"Error Activating AVSession", error.description);
            return;
        }
        
        NSDictionary * settings = [self recordSettingsForOptions:options];
        
        AVAudioRecorder * recorder = [[AVAudioRecorder alloc]
                                      initWithURL:[self createNewTempFile]
                                      settings:settings
                                      error:&error];
        
        if (error) {
            jlog_warning_join(@"Error Setting Up AVAudioRecorder", error.description);
            return;
        }
        
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
    
        [recorder prepareToRecord];
        self.recorder = recorder;
        
        // TODO: Add duration in JLJParams options
        [self recordForDuration:DEFAULT_MAX_DURATION];
        
    } showAlert:YES];
}

- (NSDictionary *) audioFileParams {
    NSData * data = [NSData dataWithContentsOfURL:self.file];
    NSString * base64 = [self.app.utils.base64 encode:data];
        
    NSString * contentType = @"audio/m4a";
    
    NSString * dataString = [NSString stringWithFormat:@"data:%@;base64,%@", contentType, base64];
    
    NSURL * dataURI = [NSURL URLWithString:dataString];
    
    AVURLAsset * audioAsset = [AVURLAsset URLAssetWithURL:self.file options:nil];
    CMTime audioDuration = audioAsset.duration;
    Float64 seconds = CMTimeGetSeconds(audioDuration);
    NSString * duration = [self timeStringForTimeInterval:seconds];
    
    return @{
        @"status": [self currentStatus],
        @"file": @{
            @"url": self.file.absoluteString,
            @"url_components": self.file.pathComponents,
            @"data": dataString,
            @"uri": dataURI.absoluteString,
            @"content_type": contentType,
            @"time": @{
                @"formatted": duration,
                @"total": @(seconds),
            }
        },
        
    };
}

#pragma mark - AVAudioRecorderDelegate

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL) flag {
    BOOL succeeded = flag;
    
    jlog_trace_fmt(@"AVAudioRecorder Did Finish Recording %@ At Path %@", (succeeded ? @"success" : @"failure"), self.file.absoluteString);
    
    [self.recorder updateMeters];
    [self stopDurationTimer];
    
    self.state = JLAudioStateIdle;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.app.utils.webview
         dispatch:kJLAudioRecorderDidFinishEvent
         arguments:[self audioFileParams]
         inWebView:self.ext.webview];
        
        // Call webview with params
        // TODO: If the file is removed then it will not be possible
        // to play afterwards.
        // Maybe add a way to delete temp files after play?
        // [self.app.utils.fs removeFileAtPath:self.file.path];
        [self enableIdleTimer];
    });
}

- (void)audioRecorderEncodeErrorDidOccur:(AVAudioRecorder *)recorder error:(NSError *)error {
    jlog_warning_join(error.description);
    
    [self.recorder updateMeters];
    [self stopDurationTimer];
    
    self.state = JLAudioStateIdle;
    
    
    // Call webview with params
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.app.utils.webview
         dispatch:kJLAudioRecorderDidErrorEvent
         arguments:@{
            @"message": error.localizedDescription,
            @"code": @(error.code),
            @"info": error.userInfo,
            @"file": @{
                @"url": self.file.absoluteString,
                @"url_components": self.file.pathComponents
            }
        }
         inWebView:self.ext.webview];
    });
    
    // Remove temp file
    [self.app.utils.fs removeFileAtPath:self.file.path];
    [self enableIdleTimer];
}
@end
