/*****
 * Tencent is pleased to support the open source community by making QMUI_iOS available.
 * Copyright (C) 2016-2018 THL A29 Limited, a Tencent company. All rights reserved.
 * Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
 * http://opensource.org/licenses/MIT
 * Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
 *****/
//
//  NSArray+QMUI.m
//  QMUIKit
//
//  Created by MoLice on 2017/11/14.
//

#import "NSArray+QMUI.h"

@implementation NSArray (QMUI)

- (void)qmui_enumerateNestedArrayWithBlock:(void (^)(id, BOOL *))block {
    BOOL stop = NO;
    for (NSInteger i = 0; i < self.count; i++) {
        id object = self[i];
        if ([object isKindOfClass:[NSArray class]]) {
            [((NSArray *)object) qmui_enumerateNestedArrayWithBlock:block];
        } else {
            block(object, &stop);
        }
        if (stop) {
            return;
        }
    }
}

- (NSMutableArray *)qmui_mutableCopyNestedArray {
    NSMutableArray *mutableResult = [self mutableCopy];
    for (NSInteger i = 0; i < self.count; i++) {
        id object = self[i];
        if ([object isKindOfClass:[NSArray class]]) {
            NSMutableArray *mutableItem = [((NSArray *)object) qmui_mutableCopyNestedArray];
            [mutableResult replaceObjectAtIndex:i withObject:mutableItem];
        }
    }
    return mutableResult;
}

- (instancetype)qmui_filterWithBlock:(BOOL (^)(id))block {
    if (!block) {
        return self;
    }
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < self.count; i++) {
        id item = self[i];
        if (block(item)) {
            [result addObject:item];
        }
    }
    return [result copy];
}

@end
