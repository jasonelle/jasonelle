//
//  JLContacts.m
//  JLContacts
//
//  Created by clsource on 05-02-23.
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

#import "JLContacts.h"
#import "JLContactsQueryAllMessageHandler.h"

@implementation JLContacts

#pragma mark - Helpers

- (CNContactStore *) contacts {
    if(!_contacts) {
        _contacts = [CNContactStore new];
    }
    return _contacts;
}

- (void) install {
    [super install];
    
    [self authorize];
    
    JLContactsQueryAllMessageHandler * allHandler = [[JLContactsQueryAllMessageHandler alloc] initWithApplication:self.app];
    
    allHandler.contacts = self;

    self.handlers = @{
        @"$contacts.all": allHandler,
    };
}

- (void)authorize {
    
    [self.contacts requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        jlog_trace_join(@"User Contacts Authorization: ", (granted ? @"granted" : @"not granted"));

        if (error) {
            jlog_warning_join(@"Error Registering for Contacts Usage", error.description);
        }
    }];
}

- (nonnull WKWebView *)appDidLoadWithWebView:(nonnull WKWebView *)webView {
    [super appDidLoadWithWebView:webView];
    
    // Install the wrappers inside the webview
    
    NSString * js = [self.app.utils.fs
                     readJSFor:self];
    
    WKUserScript * script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    [webView.configuration.userContentController addUserScript: [script copy]];
    
    return webView;
}


- (BOOL) granted {
    switch (self.status)  {
        case CNAuthorizationStatusAuthorized:
        case CNAuthorizationStatusRestricted:
                return YES;
                break;
        case CNAuthorizationStatusDenied:
        case CNAuthorizationStatusNotDetermined:
                return NO;
                break;
    }
}

- (CNAuthorizationStatus) status {
    return [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
}

#pragma mark - Queries
- (NSArray *) all {
    
    jlog_trace(@"Fetching all Contacts");
    
    if(!self.granted) {
        jlog_warning_join(@"Error Fetching Contacts. Permissions not Granted.");
        return @[];
    }
    
    
    NSPredicate * predicate = [CNContainer
                               predicateForContainersWithIdentifiers: @[self.contacts.defaultContainerIdentifier]];
    
    NSError * error = nil;
    
    [self.contacts containersMatchingPredicate:predicate error:&error];
    
    NSArray * keysToFetch =
        @[CNContactEmailAddressesKey,
          CNContactPhoneNumbersKey,
          CNContactFamilyNameKey,
          CNContactGivenNameKey,
          CNContactPostalAddressesKey];
    
    CNContactFetchRequest * request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    
    NSMutableArray * items = [@[] mutableCopy];
    
    CNPostalAddressFormatter * fmt = [CNPostalAddressFormatter new];
    
    [self.contacts enumerateContactsWithFetchRequest:request error:&error usingBlock:^(CNContact * __nonnull contact, BOOL * __nonnull stop){
        
            NSMutableArray * addresses = [@[] mutableCopy];
        
            for (CNPostalAddress * address in [contact.postalAddresses valueForKey:@"value"]) {
                [addresses addObject:[fmt stringFromPostalAddress:address]];
            }
        
            NSArray * phones = [[contact.phoneNumbers valueForKey:@"value"] valueForKey:@"digits"];
        
            NSArray * emails = [contact.emailAddresses valueForKey:@"value"];
        
            [items addObject: @{
                @"name": contact.givenName,
                @"lastname": contact.familyName,
                @"phone": ([phones firstObject] ? [phones firstObject] : @""),
                @"phones": [phones copy],
                @"email": ([emails firstObject] ? [emails firstObject] : @""),
                @"emails": [emails copy],
                @"address": ([addresses firstObject] ? [addresses firstObject] : @""),
                @"addresses": [addresses copy]
            }];
    }];
    
    return [items copy];
}

#pragma mark - Commands

@end
