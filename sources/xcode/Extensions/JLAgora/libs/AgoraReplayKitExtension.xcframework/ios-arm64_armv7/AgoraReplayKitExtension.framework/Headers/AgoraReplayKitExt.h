//
//  AgoraSampleHander.h
//  BroadCastUI
//
//  Created by Agora on 2022/1/25.
//  Copyright (c) 2022 Agora IO. All rights reserved.

#import <Foundation/Foundation.h>
#import <ReplayKit/ReplayKit.h>
typedef enum {
  // Failed to connect to the app process, Please call startScreenCapture in the app process.
  AgoraReplayKitExtReasonConnectFail = 1,
  // Disconnected from the app process. Please Check the APP process exits or not.
  AgoraReplayKitExtReasonDisconnect = 2,
  // Stopped by the user or the app process.
  AgoraReplayKitExtReasonInitiativeStop = 3,
} AgoraReplayKitExtReason;

@class AgoraReplayKitExt;

@protocol AgoraReplayKitExtDelegate <NSObject>

- (void)broadcastFinished:(AgoraReplayKitExt* _Nonnull)broadcast
                   reason:(AgoraReplayKitExtReason)reason;

@end

NS_ASSUME_NONNULL_BEGIN
API_AVAILABLE(ios(11.0))
NS_SWIFT_NAME(AgoraReplayKitExt)
__attribute__((visibility("default")))
@interface AgoraReplayKitExt : NSObject

+ (instancetype)shareInstance;

- (void)start:(id<AgoraReplayKitExtDelegate>)delegate;
- (void)stop;
- (void)resume;
- (void)pause;
- (void)pushSampleBuffer:(CMSampleBufferRef)sampleBuffer
                withType:(RPSampleBufferType)sampleBufferType;
@end

NS_ASSUME_NONNULL_END
