//
//  JasonAppBadgeAction.h
//  Jasonette.com
//
//  Created by Camilo Castro on 22-05-22.
//  Copyright © 2022 Jasonette.com. All rights reserved.
//

#import "JasonAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface JasonAppBadgeAction : JasonAction
/* // Example JSON
 {
     "$jason": {
         "head" : {
             "actions": {
                 "$load": {
                     "type": "$render"
                 },
                 "$pull": {
                     "type": "$util.picker",
                     "options": {
                         "items": [
                             {
                                 "text": "Get Badge",
                                 "action": {
                                     "trigger": "get_badge"
                                 }
                             },
                             {
                                 "text": "Set Badge",
                                 "action": {
                                     "trigger": "set_badge"
                                 }
                             },
                             {
                                 "text": "Clear Badge",
                                 "action": {
                                     "trigger": "clear_badge"
                                 }
                             },
                             {
                                 "text": "Refresh Web View",
                                 "action": {
                                     "type": "$agent.request",
                                     "options": {
                                         "id": "$webcontainer",
                                         "method": "(() => document.location.reload())",
                                         "params": []
                                     }
                                 }
                             }
                         ]
                     }
                 },
                 "set_badge": {
                     "type": "$appbadge.set",
                     "options": {
                         "number": 13
                     }
                 },
                 "clear_badge": {
                     "type": "$appbadge.clear"
                 },
                 "get_badge": {
                     "type": "$appbadge.get",
                     "success": {
                         "type": "$util.alert",
                         "options": {
                             "title": "{{$jason.number}}"
                         }
                     }
                 }
             },
             "templates": {
                 "body": {
                     "background": {
                         "type": "html",
                         "url": "https://www.google.com",
                         "style": {
                             "background": "#ffffff",
                             "progress" : "rgba(0,0,0,0)"
                         },
                         "options": {
                            "pull": true
                         },
                         "action": {
                             "type": "$default"
                         }
                     }
                 }
             }
         }
     }
 }
 */
@end

NS_ASSUME_NONNULL_END
