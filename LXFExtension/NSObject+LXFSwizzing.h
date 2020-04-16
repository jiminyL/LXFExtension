//
//  NSObject+LXFSwizzing.h
//  TestExtension
//
//  Created by 梁啸峰 on 2020/4/15.
//  Copyright © 2020 guanniu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LXFSwizzing)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
