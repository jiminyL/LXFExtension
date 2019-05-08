//
//  LXFBannerView.m
//  TestBannerView
//
//  Created by 梁啸峰 on 2019/3/1.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_BannerView.h"

#import "LXF_config.h"

#import "LXF_StyledPageControl.h"
#import "UIImageView+AFNetworking.h"


@interface LXF_BannerView()<UIScrollViewDelegate>

@property (nonatomic, strong) LXF_StyledPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *preIV;
@property (nonatomic, strong) UIImageView *midIV;
@property (nonatomic, strong) UIImageView *nextIV;

@property (nonatomic) dispatch_source_t timer;

@property (nonatomic) BOOL canAutoScroll;
@property (nonatomic) BOOL frozenTime;

@end

@implementation LXF_BannerView

- (instancetype)init
{
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor blackColor]];
        
        self.canAutoScroll = YES;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selfDidTouchEvent)];
        [self setUserInteractionEnabled:YES];
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

- (void)startTimer
{
    dispatch_queue_t queue = dispatch_get_main_queue();
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, 3 * NSEC_PER_SEC, 3 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    __weak typeof(self) mself = self;
    dispatch_source_set_event_handler(self.timer, ^{
        if (self.canAutoScroll && !self.frozenTime) {
            [mself.scrollView setContentOffset:CGPointMake(mself.scrollView.contentOffset.x + mself.scrollView.bounds.size.width, 0.f) animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.35 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [mself scrollToNext];
            });
        }
    });
    dispatch_resume(self.timer);
}

- (void)stopTimer
{
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self refreshViews];
}

- (void)setBannerModelArr:(NSArray<LXFBannerModel *> *)bannerModelArr
{
    _bannerModelArr = bannerModelArr;
    
    [self refreshViews];
    
    self.currentIndex = 0;
    
    if (bannerModelArr.count > 0) {
        [self startTimer];
    }
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    LXFBannerModel *currentBanner = self.bannerModelArr[currentIndex];
    [self.midIV setImageWithURL:[NSURL URLWithString:strOrEmpty(currentBanner.imageUrl)] placeholderImage:[UIImage imageNamed:@"common_bg_defaultError_2x1.png"]];
    
    NSInteger preIndex;
    if (currentIndex == 0) {
        preIndex = self.bannerModelArr.count - 1;
    }else {
        preIndex = currentIndex - 1;
    }
    LXFBannerModel *preBanner = self.bannerModelArr[preIndex];
    [self.preIV setImageWithURL:[NSURL URLWithString:strOrEmpty(preBanner.imageUrl)] placeholderImage:[UIImage imageNamed:@"common_bg_defaultError_2x1.png"]];
    
    NSInteger nextIndex;
    if (currentIndex == (self.bannerModelArr.count - 1)) {
        nextIndex = 0;
    }else {
        nextIndex = currentIndex + 1;
    }
    LXFBannerModel *nextBanner = self.bannerModelArr[nextIndex];
    [self.nextIV setImageWithURL:[NSURL URLWithString:strOrEmpty(nextBanner.imageUrl)] placeholderImage:[UIImage imageNamed:@"common_bg_defaultError_2x1.png"]];

    [self.scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0.f)];
    
    self.pageControl.currentPage = (int)self.currentIndex;
}

- (void)refreshViews
{
    if (!self.scrollView) {
        self.scrollView = [[UIScrollView alloc] init];
        [self.scrollView setDelegate:self];
        [self.scrollView setPagingEnabled:YES];
        [self.scrollView setBounces:YES];
        [self.scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:self.scrollView];
    }
    [self.scrollView setFrame:self.bounds];
    
    if (!self.pageControl) {
        self.pageControl = [[LXF_StyledPageControl alloc]initWithFrame:CGRectZero];
        self.pageControl.coreNormalColor = [UIColor whiteColor];
        self.pageControl.coreSelectedColor= [UIColor colorWithHex:@"#E62129"];
        self.pageControl.numberOfPages = 0;
        self.pageControl.currentPage = 0;
        self.pageControl.strokeWidth = 0;
        self.pageControl.diameter = 7;
        self.pageControl.gapWidth = 20;
        [self addSubview:self.pageControl];
    }
    self.pageControl.numberOfPages = (int)self.bannerModelArr.count;
    CGFloat pageWidth = self.bannerModelArr.count * 12.f;
    [self.pageControl setFrame:CGRectMake((self.width - pageWidth)/2, self.height - 25.f, pageWidth, 12.f)];
    
    CGFloat offsetX = 0.f;
    if (!self.preIV) {
        self.preIV = [[UIImageView alloc] init];
        [self.scrollView addSubview:self.preIV];
    }
    [self.preIV setFrame:CGRectMake(offsetX, 0.f, self.bounds.size.width, self.bounds.size.height)];
    offsetX += self.bounds.size.width;
    
    if (!self.midIV) {
        self.midIV = [[UIImageView alloc] init];
        [self.scrollView addSubview:self.midIV];
    }
    [self.midIV setFrame:CGRectMake(offsetX, 0.f, self.bounds.size.width, self.bounds.size.height)];
    offsetX += self.bounds.size.width;
    
    if (!self.nextIV) {
        self.nextIV = [[UIImageView alloc] init];
        [self.scrollView addSubview:self.nextIV];
    }
    [self.nextIV setFrame:CGRectMake(offsetX, 0.f, self.bounds.size.width, self.bounds.size.height)];
    offsetX += self.bounds.size.width;
    
    [self.scrollView setContentSize:CGSizeMake(offsetX, self.bounds.size.height)];
}

#pragma mark - ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.canAutoScroll = NO;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.canAutoScroll = YES;
    self.frozenTime = YES;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.frozenTime = NO;
    });
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ((scrollView.contentOffset.x > - 50.f) && (scrollView.contentOffset.x < 50.f)) {
        [self scrollToPre];
    }else if ((scrollView.contentOffset.x > (self.scrollView.bounds.size.width - 50.f)) && (scrollView.contentOffset.x < (self.scrollView.bounds.size.width + 50.f))) {
        
    }else if ((scrollView.contentOffset.x > (self.scrollView.bounds.size.width*2 - 50.f)) && (scrollView.contentOffset.x < (self.scrollView.bounds.size.width*2 + 50.f))) {
        [self scrollToNext];
    }
}

- (void)scrollToPre
{
    if (self.currentIndex == 0) {
        self.currentIndex = (self.bannerModelArr.count - 1);
    }else {
        self.currentIndex -= 1;
    }
}

- (void)scrollToNext
{
    if (self.currentIndex >= (self.bannerModelArr.count - 1)) {
        self.currentIndex = 0;
    }else {
        self.currentIndex += 1;
    }
}

- (void)selfDidTouchEvent
{
    LXFBannerModel *currentBanner = self.bannerModelArr[self.currentIndex];
    if (self.didTouchEvent) {
        self.didTouchEvent(currentBanner);
    }
}

@end

//Model -----------------------------------------------
@implementation LXFBannerModel



@end
