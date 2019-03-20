//
//  COFloatView.m
//  iBuilding
//
//  Created by 梁啸峰 on 2018/10/11.
//

#import "LXF_FloatView.h"

#import "UIView+LXFSizes.h"

@interface LXF_FloatView()

@property (nonatomic, strong) UIView *bgView;

@end

@implementation LXF_FloatView

- (instancetype)initWithLocationStyle:(FloatViewContentLocation)location andCustomSize:(BOOL)customSize
{
    if (self = [super init]) {
        self.location = location;
        self.customSize = customSize;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self initViews];
}

- (void)setContentView:(UIView *)contentView
{
    _contentView = contentView;
    
    [self initViews];
}

- (void)initViews
{
    if (!self.bgView) {
        self.bgView = [[UIView alloc] init];
        [self addSubview:self.bgView];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgViewTouchEvent)];
        [self.bgView setUserInteractionEnabled:YES];
        [self.bgView addGestureRecognizer:tapGes];
    }
    [self.bgView setFrame:self.bounds];
    [self.bgView setBackgroundColor:[UIColor blackColor]];
    [self.bgView setAlpha:0.3f];
    
    if (self.contentView) {
        for (UIView *view in self.subviews) {
            if (view != self.bgView) {
                [view removeFromSuperview];
            }
        }
        [self addSubview:self.contentView];
    }
    CGFloat height = self.customSize ? self.contentView.height : (8.f/10)*self.height;
    CGFloat width = self.customSize ? self.contentView.width : self.width;
    [self.contentView setFrame:CGRectMake((self.width - width)/2, self.height, self.customSize ? self.contentView.width : self.width, height)];
}

- (void)changeContentViewFrame
{
    __weak typeof(self) mself = self;
    [UIView animateWithDuration:0.2 animations:^{
        CGFloat height = mself.customSize ? mself.contentView.height : (8.f/10)*mself.height;
        CGFloat y = mself.customSize ? mself.location == FloatViewContentLocationBottom ? (mself.height - height) : ((mself.height - height))/2: (2.f/10)*mself.height;
        CGFloat width = mself.customSize ? mself.contentView.width : mself.width;
        [mself.contentView setFrame:CGRectMake((mself.width - width)/2, y, width, height)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)bgViewTouchEvent
{
    [self hidden];
}

- (void)show
{
    [self setHidden:NO];
    __weak typeof(self) mself = self;
    [UIView animateWithDuration:0.35 animations:^{
        CGFloat height = mself.customSize ? mself.contentView.height : (8.f/10)*mself.height;
        CGFloat y = mself.customSize ? mself.location == FloatViewContentLocationBottom ? (mself.height - height) : ((mself.height - height))/2 : (2.f/10)*mself.height;
        CGFloat width = mself.customSize ? mself.contentView.width : mself.width;
        [mself.contentView setFrame:CGRectMake((mself.width - width)/2, y, width, height)];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hidden
{
    __weak typeof(self) mself = self;
    [UIView animateWithDuration:0.35 animations:^{
        CGFloat height = mself.customSize ? mself.contentView.height : (8.f/10)*mself.height;
        CGFloat width = mself.customSize ? mself.contentView.width : mself.width;
        [mself.contentView setFrame:CGRectMake((mself.width - width)/2, mself.height, width, height)];
    } completion:^(BOOL finished) {
        [mself setHidden:YES];
        [mself.contentView removeFromSuperview];
    }];
}

@end
