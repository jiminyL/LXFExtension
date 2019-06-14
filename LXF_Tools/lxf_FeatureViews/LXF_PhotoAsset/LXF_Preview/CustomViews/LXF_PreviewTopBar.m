//
//  LXF_PreviewTopBar.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/6/5.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PreviewTopBar.h"
#import "LXF_config.h"

@interface LXF_PreviewTopBar()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *selectButton;

@end

@implementation LXF_PreviewTopBar

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)setDidSeleted:(BOOL)didSeleted {
    _didSeleted = didSeleted;
    
    [self refreshViews];
}

- (void)refreshViews {
    [self.bgView setFrame:self.bounds];
    
    [self.backButton setFrame:CGRectMake(10, 10+SYS_STATUSBAR_HEIGHT, 44, 44)];
    
    [self.selectButton setFrame:CGRectMake(self.width - 54, 10+SYS_STATUSBAR_HEIGHT, 42, 42)];
    [self.selectButton setSelected:self.didSeleted];
}

#pragma mark - Event
- (void)backButtonEvent {
    if (self.backEvent) {
        self.backEvent();
    }
}

- (void)selectButtonEvent:(UIButton *)sender {
    if (self.didSelectedEvent) {
        self.didSelectedEvent(!sender.selected);
    }
    sender.selected = !sender.selected;
}

#pragma mark - Lazy
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        [_bgView setBackgroundColor:[UIColor colorWithRed:(34/255.0) green:(34/255.0)  blue:(34/255.0) alpha:1.0]];
        [_bgView setAlpha:0.7f];
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UIButton *)backButton {
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"LXF_preview_navi_back.png"] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backButton];
    }
    return _backButton;
}

- (UIButton *)selectButton {
    if (!_selectButton) {
        _selectButton = [[UIButton alloc] init];
        [_selectButton setImage:[UIImage imageNamed:@"LXF_preview_def_photoPickerVc.png"] forState:UIControlStateNormal];
        [_selectButton setImage:[UIImage imageNamed:@"LXF_preview_sel_photoPickerVc.png"] forState:UIControlStateSelected];
        [_selectButton addTarget:self action:@selector(selectButtonEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_selectButton];
    }
    return _selectButton;
}

@end
