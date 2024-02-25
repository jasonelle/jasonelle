//
//  JasonPushService.m
//  Jasonette
//
//  Created by e on 8/25/17.
//  Copyright © 2017 Jasonette. All rights reserved.
//

#import "JasonPushService.h"
#import "JasonLogger.h"

#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)


@implementation JasonPushService

- (nonnull NSDictionary *)normalize:(nullable NSDictionary *)userInfo {
    if (!userInfo) {
        return @{};
    }

    // Check if the userInfo is a string
    NSDictionary * info = userInfo[@"href"];

    if (!info) {
        info = userInfo[@"action"];
    }

    if ([info respondsToSelector:@selector(containsString:)]) {
        // Maybe the userInfo is a json object in a string
        // This can be a case when a notification payload is sent via Firebase or similar
        // That only strings are allowed in the data attribute of the notification.
        NSString * json = (NSString *)info;
        NSError * error = nil;
        id jsonObject = [NSJSONSerialization
                         JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                    options:kNilOptions
                                      error:&error];

        DTLogDebug (@"Detected and parsed json string in userInfo %@", jsonObject);
        info = jsonObject;

        if (error) {
            DTLogDebug (@"%@", error);
            info = nil;
        }
    }

    NSMutableDictionary * normalized = [userInfo mutableCopy];

    if (info) {
        if (normalized[@"href"]) {
            normalized[@"href"] = info;
        } else if (normalized[@"action"]) {
            normalized[@"action"] = info;
        }
    }

    return [normalized copy];
}

- (void)initialize:(NSDictionary *)launchOptions
{
    DTLogDebug (@"initialize");

#ifdef PUSH

    NSDictionary * userInfo = [self normalize:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];

    if (userInfo[@"href"]) {
        [[Jason client] call:@{
             @"type": @"$href",
             @"options": userInfo[@"href"]
        }];
    } else if (userInfo[@"action"]) {
        [[Jason client] call:userInfo[@"action"]];
    }

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onRemoteNotification:" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemoteNotification:) name:@"onRemoteNotification" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"onRemoteNotificationDeviceRegistered:" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onRemoteNotificationDeviceRegistered:) name:@"onRemoteNotificationDeviceRegistered" object:nil];
#else  /* ifdef PUSH */
    DTLogWarning (@"Push notification turned off by default. If you'd like to suport push, uncomment the #define statement in Constants.h and turn on the push notification feature from the capabilities tab.");
#endif /* ifdef PUSH */
}

// The "PUSH" constant is defined in Constants.h
// By default PUSH is disabled. To turn it on, go to Constants.h and uncomment the #define statement, and then go to the capabilities tab and switch the push notification feature on.

// Common remote notification processor

- (void)process:(NSDictionary *)payload
{
    NSDictionary * events = [[[Jason client] getVC] valueForKey:@"events"];

    if (events) {
        if (events[@"$push.onmessage"]) {
            DTLogDebug (@"Calling $push.onmessage event");
            [[Jason client]
             call:events[@"$push.onmessage"]
             with:@{ @"$jason": [self normalize:payload] }];
        }
    }
}

- (void)onRemoteNotification:(NSNotification *)notification
{
    [self process:notification.userInfo];
}

- (void)onRemoteNotificationDeviceRegistered:(NSNotification *)notification {
    NSDictionary * payload = [self normalize:notification.userInfo];
    NSDictionary * events = [[[Jason client] getVC] valueForKey:@"events"];

    if (events) {
        if (events[@"$push.onregister"]) {
            NSDictionary * params = @{ @"$jason": @{ @"token": @"" } };

            if (payload && payload[@"token"]) {
                params = @{ @"$jason": payload };
            }

            DTLogDebug (@"Calling $push.onregister event with params %@", params);

            [[Jason client] call:events[@"$push.onregister"] with:params];
        }
    }
}

#pragma mark - UNUserNotificationCenter Delegate above iOS 10

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler {
    [self process:notification.request.content.userInfo];
    completionHandler (UNNotificationPresentationOptionNone);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    if (response.notification.request.content.userInfo) {
        DTLogDebug (@"Received Notification Response %@", response.notification.request.content.userInfo);

        NSDictionary * userInfo = [self normalize:response.notification.request.content.userInfo];

        if (userInfo[@"href"]) {
            DTLogDebug (@"Show href");
            [[Jason client] go:userInfo[@"href"]];
        } else if (userInfo[@"action"]) {
            DTLogDebug (@"Executing Action");
            [[Jason client] call:userInfo[@"action"]];
        }
    }

    completionHandler ();
}

@end
