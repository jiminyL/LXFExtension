//
//  NSObject+LXFSwizzing.m
//  TestExtension
//
//  Created by 梁啸峰 on 2020/4/15.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import "NSObject+LXFSwizzing.h"
#import <objc/runtime.h>

@implementation NSObject (LXFSwizzing)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    // 若已经存在，则添加会失败
    BOOL didAddMethod = class_addMethod(class,originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    // 若原来的方法并不存在，则添加即可
    if (didAddMethod) {
        class_replaceMethod(class,swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
