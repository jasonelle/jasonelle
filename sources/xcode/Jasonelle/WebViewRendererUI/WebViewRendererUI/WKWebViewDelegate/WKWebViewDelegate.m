//
//  WKWebViewDelegate.m
//  WebViewRendererUI
//
//  Created by clsource on 13-05-22
//
//  Copyright (c) 2022 Jasonelle.com
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


#import "WKWebViewDelegate.h"

// TODO: Implement this as an self.app.utils method
@import SafariServices;

@implementation WKWebViewDelegate

- (NSString *)identifier {
    if (!_identifier) {
        _identifier = self.app.utils.uuid;
    }
    return _identifier;
}

- (instancetype)initWithIdentifier:(NSString *)identifier {
    self = [super init];
    if (self) {
        self.identifier = identifier;
    }
    return self;
}
- (instancetype)initWithApp:(JLApplication *)app andIdentifier:(NSString *)identifier {
    self = [self initWithIdentifier:identifier];
    if (self) {
        self.app = app;
        self.logger = app.logger;
    }
    return self;
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message replyHandler:(void (^)(id, NSString *))replyHandler
{
    // We have to use the global logger and application
    // because the reference is lost in execution
    // after triggering this event (why?).

    // if the resolve exists, it will call the Promise.resolve
    // if the reject exists, it will call Promise.reject
    // replyHandler(resolve, reject)
    //
    // example success reply
    // replyHandler(@YES, nil);
    //
    // example reject reply
    // replyHandler(nil, @"Unexpected message received");

    jlog_global_trace(@"Received Message from WebView");

    // Send the message to extensions if this is not a dictionary
    if (![message.body respondsToSelector:@selector(objectForKey:)]) {
        jlog_global_trace(@"Calling the extensions handler for webview messages");
        return [[JLApplication instance].ext.extensions userContentController:userContentController didReceiveScriptMessage:message replyHandler:replyHandler];
    }

    NSDictionary *body = (NSDictionary *) message.body;

    // Send the message to extensions if this is not a Jasonelle trigger
    if (!body[@"com.jasonelle.agent.kernel"]) {
        jlog_global_trace(@"Calling the extensions handler for webview messages");
        return [[JLApplication instance].ext.extensions userContentController:userContentController didReceiveScriptMessage:message replyHandler:replyHandler];
    }

    // Call the Kernel Handler
    return [[JLApplication instance].js.handlers
            userContentController:userContentController
           didReceiveScriptMessage:message
                      replyHandler:replyHandler];
}

// This is the old way of handling native calls from the webview
// implementing WKScriptMessageHandler protocol
// It will always return a Promise.resolve(null) on iOS >= 14
// and null otherwise.
// It is here just as an example.
// - (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
//    // For some reason the logger is null in this function. So we have to use the global logger function.
//    id<JLLoggerProtocol> logger = [JLApplication instance].logger;
//    jlog_logger_trace(logger, @"Received Message from WebView");
//    NSDictionary * body = (NSDictionary *) message.body;
//    jlog_logger_trace_join(logger, @"Message:", body.description);
// }

#pragma mark - WKWebview Delegate
//  Cool tips: https://github.com/ShingoFukuyama/WKWebViewTips
/// Overwrite links. Decide if they are allowed to be navigated to or needs to use the native browser
- (void) webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    NSString * current = navigationAction.request.URL.absoluteString;
    
    jlog_trace_join(@"Deciding Policy for URL ", current);
    
    NSArray * allowed = [[JLApplication instance].config.params array:@"allowed"];
    
    jlog_trace_join(@"Allowed List", allowed);
    
    // Be YES as default if no allowed list is present
    BOOL isAllowed = allowed.count <= 0;
    
    
    for(NSString * url in allowed) {
        jlog_trace_join(@"Does ", url, @" in ", current, @"?");
        if ([current hasSuffix:url] || [current hasPrefix:url] || [current containsString:url]) {
            jlog_trace(@"YES");
            isAllowed = YES;
        }
    }
    
    // Urls with the special schemas
    // https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/Introduction/Introduction.html#//apple_ref/doc/uid/TP40007899
    // Special case of itunes links
    // should always open the iTunes app
    // Add more if needed.
    if([current hasPrefix:@"sms:"] || [current hasPrefix:@"tel:"] || [current hasPrefix:@"mailto:"] || [current hasPrefix:@"message:"] || [current hasPrefix:@"facetime:"] || [current hasPrefix:@"facetime-audio:"] || [current containsString:@"maps.apple.com"] || [current containsString:@"phobos.apple.com"] || [current hasPrefix:@"https://itunes.apple.com"]) {
        
        jlog_trace_join(@"URL: ", current, @" is a special schema.");
        isAllowed = NO;
    }
    
    if (isAllowed) {
        return decisionHandler(WKNavigationActionPolicyAllow);
    }
   
    jlog_trace_join(@"URL: ", current, @"is not in the allowed list, or will open a special URL schema");
    
    // If you want to add more special urls and schemas
    // should also allow them in the plist.
    // https://stackoverflow.com/a/68924481
    [[JLApplication instance].utils openURL:current];
    return decisionHandler(WKNavigationActionPolicyCancel);
}

// Handles Downloads
// See https://dev.to/gualtierofr/download-files-in-a-wkwebview-boo
- (void) webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    
    NSString * mime = navigationResponse.response.MIMEType;
    NSURL * url = navigationResponse.response.URL;
    
    jlog_trace_join(@"URL: ", url, @"Mime Type: ", mime);
    
    if ([mime isEqualToString:@"text/html"]) {
        jlog_trace(@"Website detected.");
        return decisionHandler(WKNavigationResponsePolicyAllow);
    }
    
    // Handle other file formats in Safari
    // For now opening a SafariViewController is enough.
    // TODO: Move SFSafariViewController to app.utils
    // TODO: Is this enough for supporting file downloads?
    SFSafariViewControllerConfiguration * config = [SFSafariViewControllerConfiguration new];
    
    config.entersReaderIfAvailable = YES;
    
    SFSafariViewController * safari = [[SFSafariViewController alloc] initWithURL:url configuration:config];
    
    [self.app.utils present:safari completion:^{
        jlog_trace_join(@"Presented Safari for URL: ", url.absoluteString);
    }];
    
    return decisionHandler(WKNavigationResponsePolicyCancel);
}

/// Handles target=_blank links
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
     
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    
    return webView;
}

- (void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    jlog_warning_join(@"Webview Did Fail Navigation: ", error.description);
    
    // Error: Frame load interrupted
    if (error.code == 102) {
        // This error triggers when the request was canceled
        // by WKNavigationResponsePolicyCancel or WKNavigationActionPolicyCancel
        // So it must not throw a not connection event
        return;
    }
    
    JLEventReachabilityDidChange * event = (JLEventReachabilityDidChange *)[self.app.events get:JLEventReachabilityDidChange.class];
    
    [event triggerNoConnectionEvent];
}

- (void) webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    
    jlog_warning_join(@"Webview Did Fail Provisional Navigation: ", error.description);
    
    // Error: Frame load interrupted
    if (error.code == 102) {
        // This error triggers when the request was canceled
        // by WKNavigationResponsePolicyCancel or WKNavigationActionPolicyCancel
        // So it must not throw a not connection event
        return;
    }
    
    JLEventReachabilityDidChange * event = (JLEventReachabilityDidChange *)[self.app.events get:JLEventReachabilityDidChange.class];
    
    [event triggerNoConnectionEvent];
}

/// Injects JS files after the website is shown
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    // Don't evaluate if about:blank
    if ([webView.URL.absoluteString isEqualToString:@"about:blank"]) {
        return;
    }
    
    // Inject agent.js into agent context
    NSString *identifier = self.identifier;

    jlog_trace_join(@"Injecting agent.js into context ", identifier);
    NSString *agent = [[JLApplication instance].utils.fs readJS:@"agent" for:self];

    NSString *addId = [NSString
                       stringWithFormat:@"__com_jasonelle_agent.id = '%@';\n",
                       identifier];

    // Add window.jasonelle
    NSString *addInterface = [NSString
                              stringWithFormat:
                              @"__com_jasonelle_agent.interface = window.webkit.messageHandlers[`%@`];\n" \
                              @"window.jasonelle = {agent: __com_jasonelle_agent, ready: false, logger: __com_jasonelle_agent.logging.logger, version: {string: '%s', major: %d, minor: %d, patch: %d, number: %d}" \
                              @"};\n"
                              , identifier, JASONELLE_VERSION_STRING, JASONELLE_VERSION_MAJOR, JASONELLE_VERSION_MINOR, JASONELLE_VERSION_PATCH, JASONELLE_VERSION_NUMBER];

    NSString *summon = [agent
                        stringByAppendingString:[addId stringByAppendingString:addInterface]];

    jlog_trace_join(@"Injecting webview.js into context ", identifier);

    NSString *custom = [[JLApplication instance].utils.fs readJS:@"_build/webview"];

    summon = [summon stringByAppendingString:custom];

    // Load the summon code only when the DOM was loaded
    // To avoid errors on WebKit initialization
//    summon = [NSString stringWithFormat:@"document.addEventListener('DOMContentLoaded', function(_event) {%@});\n", summon];

    jlog_trace(summon);

    [webView evaluateJavaScript:summon
              completionHandler:^(id _Nullable res, NSError * _Nullable error) {
                  if (error) {
                      jlog_warning(error.description);
                      return;
                  }

                  jlog_trace(@"Injected agent.js and webview.js into context");

              }];
}

#pragma mark - JS Alert Prompts

// TODO: Allow for more type of alerts. For example an Alert to Go Settings or Rate the App.
// This can be done by passing a json encoded string in the message.
// Maybe add a method in $agent to trigger an alert with JSON object
- (void) webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler {
    
    jlog_global_trace(@"Webview UI: JS Alert Panel Called");

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler();
    }]];
    
    UIViewController * controller = [JLApplication instance].rootController;
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler
{
    jlog_global_trace(@"Webview UI: JS Confirm Panel Called");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(NO);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler(YES);
    }]];
    
    UIViewController * controller = [JLApplication instance].rootController;
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString *result))completionHandler
{
    
    jlog_global_trace(@"Webview UI: JS Text Input Panel Called");
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:prompt
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = prompt;
        textField.secureTextEntry = NO;
        textField.text = defaultText;
    }];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        completionHandler(nil);
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        completionHandler([alert.textFields.firstObject text]);
    }]];
    
    UIViewController * controller = [JLApplication instance].rootController;
    [controller presentViewController:alert animated:YES completion:nil];
}
@end
