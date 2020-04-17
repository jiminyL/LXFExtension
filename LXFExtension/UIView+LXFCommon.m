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

@end
