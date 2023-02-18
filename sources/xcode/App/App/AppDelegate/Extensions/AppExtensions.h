//
//  AppExtensions.h
//  App
//
//  Created by Camilo Castro on 17-02-23.
//

#import <Foundation/Foundation.h>
#import <Jasonelle/Jasonelle.h>

// Extensions
#import <JLATTrackingManager/JLATTrackingManager.h>
#import <JLApplicationBadge/JLApplicationBadge.h>
#import <JLPhotoLibrary/JLPhotoLibrary.h>
#import <JLKeychain/JLKeychain.h>
#import <JLCookies/JLCookies.h>
#import <JLContacts/JLContacts.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppExtensions : NSObject

@property (nonatomic, strong, nonnull) JLApplication * app;
@property (nonatomic, strong, nonnull) id<JLLoggerProtocol> logger;

@property (nonatomic, strong, nonnull ) JLExtensions * extensions;

- (instancetype) initWithApp: (JLApplication *) app;
- (BOOL) install;

@end

NS_ASSUME_NONNULL_END
