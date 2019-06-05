//
//  LXF_FitView.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/3/26.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_FitView.h"

#import "LXF_config.h"

@implementation LXF_FitView

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)refreshViews {
    if (self.height == HEIGHT_TO_Fit && self.content_height > 0) {
        self.height = self.content_height;
    }
    if (self.width == WIDTH_TO_Fit && self.content_width > 0) {
        self.width = self.content_width;
    }
}

@end
