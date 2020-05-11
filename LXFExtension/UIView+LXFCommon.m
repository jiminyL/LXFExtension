//
//  UIView+LXFCommon.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2020/4/17.
//  Copyright © 2020 GuanNiu. All rights reserved.
//

#import "UIView+LXFCommon.h"

@implementation UIView (LXFCommon)

- (void)rotaion180 {
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformMakeRotation(M_PI);
    }];
}

- (void)rotationToOrg {
    [UIView animateWithDuration:0.35 animations:^{
        self.transform = CGAffineTransformMakeRotation(0);
    }];
}

///增加渐变
- (void)addGradientWithColors:(NSArray<UIColor *> *)colors horizontal:(BOOL)isHorizontal{
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 0);
    layer.endPoint = CGPointMake(isHorizontal ? 1:0, isHorizontal ? 0 : 1);
    NSMutableArray *cgColors = [[NSMutableArray alloc] initWithCapacity:colors.count];
    NSMutableArray *locations = [[NSMutableArray alloc] initWithCapacity:colors.count];
    CGFloat space = 1.f / (colors.count - 1);
    CGFloat offset = 0.f;
    for (int i=0; i<colors.count; i++) {
        UIColor *c = colors[i];
        [cgColors addObject:(__bridge id)c.CGColor];
        if (i==0) {
            [locations addObject:@0];
        }else if (i==colors.count - 1) {
            [locations addObject:@1];
        }else {
            [locations addObject:[NSNumber numberWithFloat:offset]];
        }
        offset += space;
    }
    layer.colors = cgColors;
    layer.locations = locations;
    layer.frame = self.layer.bounds;
    [self.layer insertSublayer:layer atIndex:0];
}

@end
