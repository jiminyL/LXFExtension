//
//  NSObject+LXFSwizzing.h
//  TestGCD
//
//  Created by 梁啸峰 on 2019/3/19.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (LXFSwizzing)

+ (void)swizzleSelector:(SEL)originalSelector withSwizzledSelector:(SEL)swizzledSelector;

@end

NS_ASSUME_NONNULL_END
