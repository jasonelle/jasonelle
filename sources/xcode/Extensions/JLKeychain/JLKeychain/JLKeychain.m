//
//  JLKeychain.m
//  JLKeychain
//
//  Created by clsource on 23-01-23
//
//  Copyright (c) 2023 Jasonelle.com
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
// =========================================
//  Based on KFKeychain
//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Keyflow AB
//    https://github.com/Keyflow/Keychain-iOS-ObjC
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.


#import "JLKeychain.h"
#import "JLKeychainSetMessageHandler.h"
#import "JLKeychainGetMessageHandler.h"
#import "JLKeychainRemoveMessageHandler.h"
#import "JLKeychainClearMessageHandler.h"

@implementation JLKeychain


- (void) install {
    [super install];
    
    JLKeychainSetMessageHandler * setHandler = [[JLKeychainSetMessageHandler alloc] initWithApplication:self.app];
    
    setHandler.keychain = self;
    
    JLKeychainGetMessageHandler * getHandler = [[JLKeychainGetMessageHandler alloc] initWithApplication:self.app];
    
    getHandler.keychain = self;
    
    JLKeychainRemoveMessageHandler * removeHandler = [[JLKeychainRemoveMessageHandler alloc] initWithApplication:self.app];
    
    removeHandler.keychain = self;
    
    JLKeychainClearMessageHandler * clearHandler = [[JLKeychainClearMessageHandler alloc] initWithApplication:self.app];
    
    clearHandler.keychain = self;
    
    self.handlers = @{
        @"$keychain.set": setHandler,
        @"$keychain.get": getHandler,
        @"$keychain.remove": removeHandler,
        @"$keychain.clear": clearHandler
    };
}

// TODO: Maybe create a wrapper for WKWebView to ease script injection
- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    
    // Install the wrappers inside the webview
    NSString * js = [self.app.utils.fs readJSFor:self];
    
    WKUserScript * script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    [webView.configuration.userContentController addUserScript: script];
    
    return webView;
}

// TODO: Support listing all keychain keys
- (NSDictionary *) all {
    return @{};
}

- (BOOL) set: (id)object key: (NSString *)key {
    return [[self class] saveObject:object forKey:key];
}

- (nullable id) get: (NSString *)key {
    return [[self class] loadObjectForKey:key];
}

- (BOOL) remove: (NSString *)key {
    return [[self class] deleteObjectForKey:key];
}

- (BOOL) clear {
    return [[self class] clear];
}

#pragma mark - KFKeychain

+ (BOOL)checkOSStatus:(OSStatus)status {
    return status == noErr;
}

+ (NSMutableDictionary *)keychainQueryForKey:(NSString *)key {
    return [@{(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
              (__bridge id)kSecAttrService : key,
              (__bridge id)kSecAttrAccount : key,
              (__bridge id)kSecAttrAccessible : (__bridge id)kSecAttrAccessibleAfterFirstUnlock
              } mutableCopy];
}

/**
 @abstract Saves the object to the Keychain.
 @param object The object to save. Must be an object that could be archived with NSKeyedArchiver.
 @param key The key identifying the object to save.
 @return @p YES if saved successfully, @p NO otherwise.
 */
+ (BOOL)saveObject:(id)object forKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
    // Deleting previous object with this key, because SecItemUpdate is more complicated.
    [self deleteObjectForKey:key];
    
    NSError * error = nil;
    
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:object requiringSecureCoding:YES error:&error] forKey:(__bridge id)kSecValueData];
    
    if (error)
    {
        jlog_global_notice_fmt(@"Keychain archiving failed for key: %@, with error: %@", key, error);
    }
    
    return [self checkOSStatus:SecItemAdd((__bridge CFDictionaryRef)keychainQuery, NULL)];
}

/**
 @abstract Loads the object with specified @p key from the Keychain.
 @param key The key identifying the object to load.
 @return The object identified by @p key or nil if it doesn't exist.
 */
+ (id)loadObjectForKey:(NSString *)key {
    id object = nil;
    
    NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
    
    [keychainQuery setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    [keychainQuery setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    
    CFDataRef keyData = NULL;
    
    if ([self checkOSStatus:SecItemCopyMatching((__bridge CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData)]) {
        @try {
            NSError * error = nil;
            object = [NSKeyedUnarchiver
                      unarchivedObjectOfClasses:[[NSSet alloc] initWithArray:@[NSDictionary.class, NSString.class, NSNumber.class, NSArray.class]]
                      fromData:(__bridge NSData *)keyData
                      error:&error];
            if (error) {
                jlog_global_notice_fmt(@"Keychain Unarchiving for key %@ failed with error %@", key, error);
                object = nil;
            }
        }
        @catch (NSException *exception) {
            jlog_global_notice_fmt(@"Keychain Unarchiving for key %@ failed with exception %@", key, exception.name);
            object = nil;
        }
        @finally {}
    }
    
    if (keyData) {
        CFRelease(keyData);
    }
    
    return object;
}

/**
 @abstract Deletes the object with specified @p key from the Keychain.
 @param key The key identifying the object to delete.
 @return @p YES if deletion was successful, @p NO if the object was not found or some other error ocurred.
 */
+ (BOOL)deleteObjectForKey:(NSString *)key {
    NSMutableDictionary *keychainQuery = [self keychainQueryForKey:key];
    return [self checkOSStatus:SecItemDelete((__bridge CFDictionaryRef)keychainQuery)];
}

// https://stackoverflow.com/a/14086320
+ (BOOL) clear {
    NSArray *secItemClasses = @[(__bridge id)kSecClassGenericPassword,
                           (__bridge id)kSecClassInternetPassword,
                           (__bridge id)kSecClassCertificate,
                           (__bridge id)kSecClassKey,
                           (__bridge id)kSecClassIdentity];
    
    for (id secItemClass in secItemClasses) {
        NSDictionary *spec = @{(__bridge id)kSecClass: secItemClass};
        SecItemDelete((__bridge CFDictionaryRef)spec);
    }
    
    return YES;
}
@end
