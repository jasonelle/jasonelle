//
//  JLApplicationExtensions.m
//  JLKernel
//
//  Created by clsource on 06-05-22
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

#import <JLKernel/JLApplicationExtensions.h>

@implementation JLApplicationExtensions

- (NSDictionary *)registry {
    if (!_registry) {
        _registry = @{};
    }

    return _registry;
}

- (instancetype)initWithApplication:(JLApplication *)app andLogger:(nonnull id<JLLoggerProtocol>)logger {
    self = [super init];

    if (self) {
        self.app = app;
        self.logger = logger;
    }

    return self;
}

- (NSArray<JLExtension *> *)add:(JLExtension *)ext {
    if (ext) {
        NSMutableDictionary *dic = [self.registry mutableCopy];
        [ext install];
        [dic setObject:ext forKey:ext.name];
        self.registry = [dic copy];
    }

    return [self.registry allValues];
}

- (JLExtension *)get:(Class)extclass {
    return self.registry[[JLExtension namespaceForClass:extclass]];
}

- (void)install:(Class)extclass {
    id<JLExtensionProtocol> extension = [[extclass alloc] init];

    extension.app = self.app;
    extension.logger = self.logger;
    [self add:extension];
}

@end
