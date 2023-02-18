//
//  AppExtensions.m
//  App
//
//  Created by Camilo Castro on 17-02-23.
//

#import "AppExtensions.h"

@implementation AppExtensions

- (instancetype) initWithApp: (JLApplication *) app {
    self = [super init];
    if (self) {
        self.app = app;
        self.logger = app.logger;
        self.extensions = [[JLExtensions alloc] initWithApp:app];
    }
    return self;
}

#pragma mark - Configure Your Extensions

- (BOOL) install {
    // Setup ATTracking Manager
    [self.extensions add:JLATTrackingManager.class];
    
    // Setup permissions in info.plist to access photos
    [self.extensions add:JLPhotoLibrary.class];
    
    // Add $badge extension
    [self.extensions add:JLApplicationBadge.class];
    
    // Add $keychain extension
    [self.extensions add:JLKeychain.class];
    
    // Add $cookies extension
    [self.extensions add:JLCookies.class];
    
    // Add $contacts extension
    [self.extensions add:JLContacts.class];
    
    return [self.extensions install];
}

// Example Getting an Extensions from App
//
//- (JLATTrackingManager *) attracking {
//    return (JLATTrackingManager *) [self.app.ext get:JLATTrackingManager.class];
//}
//
//- (JLApplicationBadge *) badge {
//    return (JLApplicationBadge *) [self.app.ext get:JLApplicationBadge.class];
//}

@end
