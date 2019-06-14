//
//  LXF_PhotoSeleteView.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/10.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PhotoSeleteView.h"

#import "LXF_config.h"

@interface LXF_PhotoSeleteView()

@property (nonatomic, strong) UIImageView *selecteIV;

@end

@implementation LXF_PhotoSeleteView

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)setDidSelected:(BOOL)didSelected {
    _didSelected = didSelected;
    
    [self refreshViews];
}

- (void)refreshViews {
    [self.selecteIV setFrame:CGRectMake(self.width - 27.f, 0.f, 27.f, 27.f)];
    if (self.didSelected) {
        [self.selecteIV setImage:[UIImage imageNamed:@"LXF_Photo_Seleted.png"]];
    }else {
        [self.selecteIV setImage:[UIImage imageNamed:@"LXF_Photo_unSeleted.png"]];
    }
}

#pragma mark - Lazy
- (UIImageView *)selecteIV {
    if (!_selecteIV) {
        _selecteIV = [[UIImageView alloc] init];
        [self addSubview:_selecteIV];
    }
    return _selecteIV;
}

@end
