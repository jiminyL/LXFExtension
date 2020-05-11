//
//  UIView+LXFCommon.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LXFCommon)

- (void)rotaion180;
- (void)rotationToOrg;
///增加渐变
- (void)addGradientWithColors:(NSArray<UIColor *> *)colors horizontal:(BOOL)isHorizontal;

@end

NS_ASSUME_NONNULL_END
