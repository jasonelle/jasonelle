//
//  JLAppDelegate.m
//  Jasonelle
//
//  Created by clsource on 01-02-22
//
//  Copyright (c) 2022 Jasonelle.com
//
//  This Source Code Form is subject to the terms
//  of the Mozilla Public License, v. 2.0.
//  If a copy of the MPL was not distributed
//  with this file, You can obtain one at
//
//  https://mozilla.org/MPL/2.0/.
//

#import "JLAppDelegate.h"
#import "Love.h"

static NSString *DNS = @"com.jasonelle";

@implementation JLAppDelegate

- (void)setApp {
    self.app = [JLApplication new];
    [JLApplication setInstance:self.app];
}

- (void)setEnv:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions {
    JLEnvironment *env = [[JLEnvironment alloc] initWithApplication:application andLaunchOptions:launchOptions];

    env.licensed = I_LOVE_JASONELLE;
    self.app.env = env;
}

- (void)setLogger {
    // Configure with a custom handler if needed
    JLStreamLogHandler *handler;

    handler = [[JLStreamLogHandler alloc] initWithLabel:DNS andLevel:[JLLogLevelFactory warning]];

    if (self.app.env.type == JLEnvironmentTypeDevelop) {
        handler = [[JLStreamLogHandler alloc] initWithLabel:DNS andLevel:[JLLogLevelFactory trace]];
    }

    JLLogger *logger = [[JLLogger alloc] initWithLabel:@"ios" andHandler:handler];

    [JLLoggingSystem boot:logger];

    self.logger = logger;
    self.app.logger = logger;

    // Example of a more complex log message
    // [JLLoggingSystem.logger log:[JLLogLevelFactory trace] message:message metadata:nil source:NSStringFromClass([self class]) file:[@(__FILE__) lastPathComponent] function:@(__PRETTY_FUNCTION__) line:@(__LINE__)]

    jlog_trace(@"Logger Ready");
}

- (void)setHTTPClient {
    jlog_trace(@"Installing HTTP Client");
    // self.app.http.client = [[JLHTTPClient alloc] initWithLogger:self.logger];
    jlog_trace(@"HTTP Client Ready");
}

- (void)setJSEngine {
    jlog_trace(@"Installing JS Engine");

    self.app.js = [[JLJSContext alloc]
                   initWithLogger:self.logger
                     andSourceURL:@"com.jasonelle.app"];

    self.app.js.app = self.app;
    self.app.js.handlers = [[JLJSMessageHandlers alloc]
                            initWithApplication:self.app
                                      andLogger:self.logger];

    [JLJSBridgeLogger installInContext:self.app.js];
    [JLJSBridgei18n installInContext:self.app.js];
    [JLJSBridgeOpenURL installInContext:self.app.js];

    JLJSBridgeApp *appBridge = [JLJSBridgeApp installInContext:self.app.js];

    [JLJSPolyfillCrypto installInContext:self.app.js];

    // Export Global variables to the global JSContext
    [appBridge installGlobalVariables];

    // TODO: Add Bridge to NSLocalizedString

    // Execute main app script
    [self.app.js evalJSFile:@"_build/app"];

    if (self.app.js.context.exception) {
        NSString *message = @"JS Engine could not be booted due to JS Exception raised.";
        jlog_error(message);
        NSException *ex = [[NSException alloc] initWithName:@"com.jasonelle.boot.exception" reason:message userInfo:nil];
        [ex raise];
        return;
    }

    jlog_trace(@"JS Engine Ready");
}

- (void)setEvents {
    jlog_trace(@"Installing Events");

    // MARK: - Automatic Events
    JLEvent *orientationDidChange = [[JLEventOrientationDidChange alloc] initWithCenter:self.app.notifications andLogger:self.logger];

    // This event needs the env vars
    orientationDidChange.env = self.app.env;
    // This event would not trigger unless it is present a
    // onOrientationDidChange in the js component
    [self.app.events add:orientationDidChange];

    [self.app.events add:[[JLEventAppDidEnterBackground alloc] initWithCenter:self.app.notifications andLogger:self.logger]];

    [self.app.events add:[[JLEventAppWillEnterForeground alloc] initWithCenter:self.app.notifications andLogger:self.logger]];

    // MARK: - Events that are triggered on the renderer
    [self.app.events add:[[JLEventAppDidLoad alloc] initWithCenter:self.app.notifications andLogger:self.logger]];

    [self.app.events add:[[JLEventViewDidAppear alloc] initWithCenter:self.app.notifications andLogger:self.logger]];

    [self.app.events add:[[JLEventViewDidDisappear alloc] initWithCenter:self.app.notifications andLogger:self.logger]];

    // MARK: - Events that are triggered on App Delegate

    [self.app.events add:[[JLEventDidReceiveOpenURL alloc] initWithCenter:self.app.notifications andLogger:self.logger]];

    // TODO: add url schemes events
    // add oauth events
    // add push notification events
    // add push notification json events (if the push contains json data)
}

- (void)setLicense {
    if (!I_LOVE_JASONELLE) {

        printf("\n========================\n");
        printf("⚠️ A T T E N T I O N ⚠️");
        printf("\n========================\n");
        printf("\nThis app will crash in Production or Hardware if Love.h is not activated.\n");
        printf("Please, become a member of Jasonelle's Friends. See more info at https://jasonelle.gumroad.com\n");
        printf("\n========================\n\n");

        if ((self.app.env.device == JLEnvironmentDeviceHardware) || (self.app.env.type == JLEnvironmentTypeProduction)) {
            [[[NSException alloc] initWithName:@"Free Version" reason:@"Please, become a member of Jasonelle's Friends. See more info at https://jasonelle.gumroad.com" userInfo:@{}] raise];
        }

        return;
    }

    // Set the values in Jasonelle/Love.h
    self.app.env.licenseKey = @(JASONELLE_KEY);

    printf("\n===================================================\n");
    printf("❤️ THANKS FOR SUPPORTING JASONELLE'S DEVELOPMENT ❤️");
    printf("\n===================================================\n\n");
}

- (BOOL)              application:(UIApplication *)application
    didFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions {
    [self setApp];
    [self setEnv:application launchOptions:launchOptions];
    [self setLicense];

    [self setLogger];
    [self setHTTPClient];
    [self setEvents];
    [self setJSEngine];

    jlog_trace(@"Jasonelle Boot Complete");

    return YES;
}

// TODO: Add custom url schemes
// so it can open urls or oauth
// see: https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app

#pragma mark - Event Listeners

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    
    jlog_trace_join(@"Event Did Receive Open URL: ", url.description);
    
    JLEventDidReceiveOpenURL *event = (JLEventDidReceiveOpenURL *) [self.app.events eventFor:[JLEventDidReceiveOpenURL class]];

    
    [event triggerWithURL:url andOptions:options];

    return [self.app.ext.extensions application:app openURL:url options:options];
}

// - (void) applicationDidBecomeActive: (UIApplication *) application
// {
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//    // TODO: Add App Event
//    [self.logger
//     trace:@"Application Did Become Active"
//     function:@(__FUNCTION__)
//     line:@(__LINE__)];
// }
//
// - (void)applicationWillResignActive:(UIApplication *)application {
//// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
//// Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//    [self.logger
//     trace:@"Application Will Resign Active"
//     function:@(__FUNCTION__)
//     line:@(__LINE__)];
// }
//
//
// - (void)applicationDidEnterBackground:(UIApplication *)application {
//// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
//// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
//    [self.logger
//     trace:@"Application Did Enter Background"
//     function:@(__FUNCTION__)
//     line:@(__LINE__)];
// }
//
//
// - (void)applicationWillEnterForeground:(UIApplication *)application {
//// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
//
//    [self.logger
//     trace:@"Application Will Enter Background"
//     function:@(__FUNCTION__)
//     line:@(__LINE__)];
// }
//
// - (void)applicationWillTerminate:(UIApplication *)application {
//// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
//
//    [self.logger
//     trace:@"Application Will Terminate"
//     function:@(__FUNCTION__)
//     line:@(__LINE__)];
// }

// TODO: maybe move these to own file
// TODO: call the right methods
// - (void) onForeground: (NSNotification *) notification {
//    [self.logger trace:@"Add did enter foreground"];
//    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//    // Send event
// }
//
// - (void) onBackground: (NSNotification *) notification {
//    [self.logger trace:@"App did enter background"];
//    [[NSNotificationCenter defaultCenter]
//     addObserver:self
//     selector:@selector(onForeground:)
//            name:UIApplicationDidBecomeActiveNotification
//          object:self];
//    // Send Event
// }

@end
