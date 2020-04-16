//
//  UIColor+LXFToolkit.h
//  TestGCD
//
//  Created by 梁啸峰 on 2019/3/19.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (LXFToolkit)

+ (UIColor *)colorWithHex:(NSString *)hex;

+ (UIColor *)randomColor;

- (NSString *)hexValue;

- (NSString *)hexValueWithAlpha:(BOOL)includeAlpha;

+ (UIColor *)colorWithR:(NSInteger)R G:(NSInteger)G B:(NSInteger)B;

@property (nonatomic, assign, readonly) CGFloat red;

@property (nonatomic, assign, readonly) CGFloat green;

@property (nonatomic, assign, readonly) CGFloat blue;

@property (nonatomic, assign, readonly) CGFloat alpha;

@end

NS_ASSUME_NONNULL_END
