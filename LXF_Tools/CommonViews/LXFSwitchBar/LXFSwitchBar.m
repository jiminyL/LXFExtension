//
//  PointsSwitchBar.m
//  iBuilding
//
//  Created by 梁啸峰 on 2017/8/9.
//
//

#import "LXFSwitchBar.h"
#import "LXFSwitchBarButton.h"

#import "LXF_config.h"


#define kLxfSwitchBarButtonFont [UIFont boldSystemFontOfSize:16.f]
#define kInitialTag 10000

@interface LXFSwitchBar()

@property (nonatomic) LXFSwitchBarStyleType styleType;

@property (nonatomic, strong) UIView *currentTypeBottomLine;

@property (nonatomic, strong) NSArray *nameArray;

@property (nonatomic, strong) UIFont *font;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic) BOOL scrollType;

@end

@implementation LXFSwitchBar

- (instancetype)initBottomLineStyleWithNameArray:(NSArray<NSString *> *)nameArray andTextColor:(UIColor *)textColor andLineColor:(UIColor *)lineColor
{
    return [self initBottomLineStyleWithNameArray:nameArray andTextColor:textColor andTextSeleteColor:textColor andLineColor:lineColor andFont:kLxfSwitchBarButtonFont];
}

- (instancetype)initBottomLineStyleWithNameArray:(NSArray<NSString *> *)nameArray andTextColor:(UIColor *)textColor andTextSeleteColor:(UIColor *)textSeleteColor andLineColor:(UIColor *)lineColor andFont:(UIFont *)font
{
    if (self = [super init]) {
        self.nameArray = nameArray;
        self.styleType = LXFSwitchBarStyleTypeBottomLine;
        self.font = font;
        
        for (int i=0; i<nameArray.count; i++) {
            LXFSwitchBarButton *button = [LXFSwitchBarButton buttonWithType:UIButtonTypeCustom];
            [button setTag:i+kInitialTag];
            [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:strOrEmpty(nameArray[i]) forState:UIControlStateNormal];
            [button setTitleColor:textColor forState:UIControlStateNormal];
            [button setTitleColor:textSeleteColor forState:UIControlStateSelected];
            [button.titleLabel setFont:font];
            [self addSubview:button];
        }
        
        self.currentTypeBottomLine = [[UIView alloc] init];
        [self.currentTypeBottomLine setBackgroundColor:lineColor];
        [self addSubview:self.currentTypeBottomLine];
    }
    return self;
}

- (instancetype)initBackgroundStyleWithNameArray:(NSArray<NSString *> *)nameArray andTextColor:(UIColor *)textColor andBgColor:(UIColor *)bgColor
{
    if (self = [super init]) {
        self.nameArray = nameArray;
        self.styleType = LXFSwitchBarStyleTypeBackground;
        
        for (int i=0; i<nameArray.count; i++) {
            LXFSwitchBarButton *button = [LXFSwitchBarButton buttonWithType:UIButtonTypeCustom];
            [button setTag:i+kInitialTag];
            [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:strOrEmpty(nameArray[i]) forState:UIControlStateNormal];
            [button setTitleColor:textColor forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage createImageWithColor:bgColor frame:CGRectMake(0.f, 0.f, 10.f, 10.f)] forState:UIControlStateSelected];
            [button setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor] frame:CGRectMake(0.f, 0.f, 10.f, 10.f)] forState:UIControlStateNormal];
            [button.titleLabel setFont:kLxfSwitchBarButtonFont];
            [self addSubview:button];
        }
    }
    return self;
}

- (instancetype)initNikeStyleWithNameArray:(NSArray<NSString *> *)nameArray andUnseletedImage:(UIImage *)unSeletedImage andSeletedImage:(UIImage *)seleteImage andTextColor:(UIColor *)textColor andImageAtRight:(BOOL)imageAtRight andScrollType:(BOOL)scrollType
{
    if (self = [super init]) {
        self.nameArray = nameArray;
        self.styleType = LXFSwitchBarStyleTypeNike;
        self.scrollType = scrollType;
        
        [self setUserInteractionEnabled:YES];
        
        self.scrollView = [[UIScrollView alloc] init];
        [self.scrollView setShowsVerticalScrollIndicator:NO];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:self.scrollView];
        for (int i=0; i<nameArray.count; i++) {
            NSString *titleStr = strOrEmpty(nameArray[i]);
            LXFSwitchBarButton *button = [LXFSwitchBarButton buttonWithType:UIButtonTypeCustom];
            [button setTag:i+kInitialTag];
            [button addTarget:self action:@selector(buttonEvent:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:titleStr forState:UIControlStateNormal];
            [button setTitleColor:textColor forState:UIControlStateNormal];
            [button setImage:seleteImage forState:UIControlStateSelected];
            [button setImage:unSeletedImage forState:UIControlStateNormal];
            [button.titleLabel setFont:[UIFont systemFontOfSize:16.f]];
            CGFloat titleWidth = [titleStr widthForHeight:20.f font:[UIFont systemFontOfSize:16.f]];
            if (imageAtRight) {
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, -seleteImage.size.width, 0, seleteImage.size.width)];
                [button setImageEdgeInsets:UIEdgeInsetsMake(0, (titleWidth + 5.f), 0, -(titleWidth + 5.f))];
            }else {
                [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 10.f, 0, -10.f)];
            }
            button.contentWidth = titleWidth + seleteImage.size.width + 10.f;
            [self.scrollView addSubview:button];
        }
    }
    return self;
}

- (void)resetNameArr:(NSArray<NSString *> *)nameArr
{
    NSMutableArray *buttonArr = [[NSMutableArray alloc] init];
    for (LXFSwitchBarButton *button in self.subviews) {
        if ([button isKindOfClass:[LXFSwitchBarButton class]]) {
            [buttonArr addObject:button];
        }
    }
    if (buttonArr.count == nameArr.count) {
        for (int i=0; i<nameArr.count; i++) {
            NSString *titleStr = nameArr[i];
            LXFSwitchBarButton *button = buttonArr[i];
            [button setTitle:titleStr forState:UIControlStateNormal];
        }
    }
}


- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    if (self.scrollType) {
        CGFloat height = frame.size.height;
        CGFloat offsetX = 0.f;
        for (int i=0; i<self.nameArray.count; i++) {
            LXFSwitchBarButton *button = [self viewWithTag:i+kInitialTag];
            [button setFrame:CGRectMake(offsetX, 0.f, button.contentWidth, height)];
            offsetX += (button.contentWidth + 30.f);
        }
        if (self.scrollView) {
            [self.scrollView setFrame:self.bounds];
            [self.scrollView setContentSize:CGSizeMake(offsetX, self.height)];
            [self.scrollView setHidden:NO];
        }
    }else {
        CGFloat width = frame.size.width / self.nameArray.count;
        CGFloat height = frame.size.height;
        for (int i=0; i<self.nameArray.count; i++) {
            LXFSwitchBarButton *button = [self viewWithTag:i+kInitialTag];
            [button setFrame:CGRectMake(width * i, 0.f, width, height)];
        }
        if (self.scrollView) {
            [self.scrollView setHidden:YES];
        }
    }
//    if (self.nameArray.count > 0) {
//        [self setCurrentIndex:0];
//    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    UIView *fView = self.scrollType ? self.scrollView : self;
    for (UIView *view in fView.subviews) {
        if ([view isKindOfClass:[LXFSwitchBarButton class]]) {
            LXFSwitchBarButton *tempButton = (LXFSwitchBarButton *)view;
            if ((view.tag - kInitialTag) == currentIndex) {
                tempButton.selected = YES;
            }else {
                tempButton.selected = NO;
            }
        }
    }
    
    if (self.styleType == LXFSwitchBarStyleTypeBottomLine) {
        CGFloat width = 0.f;
        for (NSString *str in self.nameArray) {
            CGFloat temp = [str widthForHeight:self.frame.size.height font:self.font];
            if (temp > width) {
                width = temp;
            }
        }
        width += 10.f;
        
        __weak LXFSwitchBar *mself = self;
        if (currentIndex < self.nameArray.count) {
            if (self.currentTypeBottomLine.frame.size.width == 0.f) {
                CGFloat buttonWidth = self.frame.size.width / self.nameArray.count;
                [mself.currentTypeBottomLine setFrame:CGRectMake(((buttonWidth - width)/2) + buttonWidth*currentIndex, self.frame.size.height - 2.f, width, 2.f)];
            }else {
                [UIView animateWithDuration:0.3 animations:^{
                    CGFloat buttonWidth = self.frame.size.width / self.nameArray.count;
                    [mself.currentTypeBottomLine setFrame:CGRectMake(((buttonWidth - width)/2) + buttonWidth*currentIndex, self.frame.size.height - 2.f, width, 2.f)];
                }];
            }
        }
    }
}

- (void)buttonEvent:(LXFSwitchBarButton *)button
{
    self.currentIndex = button.tag - kInitialTag;

    if (self.didTouchButton) {
        self.didTouchButton(self.currentIndex);
    }
}


@end
