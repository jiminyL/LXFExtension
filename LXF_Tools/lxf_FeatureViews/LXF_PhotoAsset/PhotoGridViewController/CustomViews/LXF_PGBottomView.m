//
//  LXF_PGBottomView.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/6/5.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PGBottomView.h"
#import "LXF_config.h"

@interface LXF_PGBottomView()

@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation LXF_PGBottomView

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor blackColor]];
    }
    return self;
}

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)setCount:(NSInteger)count {
    _count = count;
    
    [self refreshViews];
}

- (void)refreshViews {
    [self.doneButton setFrame:CGRectMake(self.width - 75.f, 5.f, 60.f, 30.f)];
    NSString *title;
    if (self.count <= 0) {
        title = @"完成";
        [self.doneButton setEnabled:NO];
    }else {
        title = [NSString stringWithFormat:@"完成(%d)", (int)self.count];
        [self.doneButton setEnabled:YES];
    }
    [self.doneButton setTitle:title forState:UIControlStateNormal];
}

+ (CGFloat)height {
    return kDevice_Is_iPhoneX ? 74.f : 54.f;
}

#pragma mark - Event
- (void)doneButtonEvent {
    if (self.didTouchDoneButtonEvent) {
        self.didTouchDoneButtonEvent();
    }
}

#pragma mark - Lazy
- (UIButton *)doneButton {
    if (!_doneButton) {
        _doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_doneButton setBackgroundColor:[UIColor colorWithR:31 G:160 B:21]];
        [_doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [_doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:13.f]];
        [_doneButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _doneButton.layer.masksToBounds = YES;
        _doneButton.layer.cornerRadius = 5.f;
        [_doneButton addTarget:self action:@selector(doneButtonEvent) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_doneButton];
    }
    return _doneButton;
}

@end
