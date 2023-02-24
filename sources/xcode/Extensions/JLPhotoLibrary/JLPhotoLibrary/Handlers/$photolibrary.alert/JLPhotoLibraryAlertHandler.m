//
//  JLPhotoLibraryAlertHandler.m
//  JLPhotoLibrary
//
//  Created by Camilo Castro on 24-02-23.
//  Copyright © 2023 Jasonelle.com. All rights reserved.
//

#import "JLPhotoLibraryAlertHandler.h"
#import "JLPhotoLibrary.h"

@implementation JLPhotoLibraryAlertHandler
- (void)handleWithOptions:(nonnull JLJSMessageHandlerOptions *)options {
    JLPhotoLibrary * ext = (JLPhotoLibrary *) self.extension;
    [ext presentAlertWhenDenied];
    self.resolve(@(ext.status));
}
@end
