//
//  LXF_PreviewScrollView.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/10.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PreviewScrollView.h"

#import "LXF_config.h"

@interface LXF_PreviewScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, copy) NSArray<PHAsset *> *photos;

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger allCount;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) UIImageView *preIV;
@property (nonatomic, strong) UIImageView *midIV;
@property (nonatomic, strong) UIImageView *nextIV;

@end

@implementation LXF_PreviewScrollView

- (instancetype)initWithFetchResult:(PHFetchResult *)fetchResult OrPhotos:(NSArray *)photos andIndex:(NSInteger)index {
    if (self = [super init]) {
        self.fetchResult = fetchResult;
        self.photos = photos;
        _currentIndex = index;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self refreshViews];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    CGSize tSize = CGSizeMake(self.width*[UIScreen mainScreen].scale, self.height*[UIScreen mainScreen].scale);
    
    PHAsset *currentAsset = self.fetchResult ? self.fetchResult[currentIndex] : self.photos[currentIndex];
    [[LXF_PhotoExtension sharedInstance].imageManager requestImageForAsset:currentAsset targetSize:tSize contentMode:PHImageContentModeDefault options:[LXF_PhotoExtension sharedInstance].imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [self.midIV setImage:result];
    }];
    
    NSInteger preIndex = currentIndex - 1;
    PHAsset *preAsset = self.fetchResult ? self.fetchResult[preIndex] : self.photos[preIndex];
    [[LXF_PhotoExtension sharedInstance].imageManager requestImageForAsset:preAsset targetSize:tSize contentMode:PHImageContentModeDefault options:[LXF_PhotoExtension sharedInstance].imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [self.preIV setImage:result];
    }];
    
    NSInteger nextIndex = currentIndex + 1;
    PHAsset *nextAsset = self.fetchResult ? self.fetchResult[nextIndex] : self.photos[nextIndex];
    [[LXF_PhotoExtension sharedInstance].imageManager requestImageForAsset:nextAsset targetSize:tSize contentMode:PHImageContentModeDefault options:[LXF_PhotoExtension sharedInstance].imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [self.nextIV setImage:result];
    }];
    
    [self.scrollView setContentOffset:CGPointMake(self.width, 0.f)];
}

- (void)refreshViews
{
    [self.scrollView setFrame:self.bounds];

    CGFloat offsetX = 0.f;
    [self.preIV setFrame:CGRectMake(offsetX, 0.f, self.width, self.height)];
    offsetX += self.width;
    
    [self.midIV setFrame:CGRectMake(offsetX, 0.f, self.width, self.height)];
    offsetX += self.width;
    
    [self.nextIV setFrame:CGRectMake(offsetX, 0.f, self.width, self.height)];
    offsetX += self.width;
    
    [self.scrollView setContentSize:CGSizeMake(offsetX, self.height)];

    self.currentIndex = self.currentIndex;
}

#pragma mark - ScrollViewDelegate
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
    self.currentIndex -= 1;
}

- (void)scrollToNext
{
    self.currentIndex += 1;
}

#pragma mark - data
- (NSInteger)allCount
{
    if (self.fetchResult) {
        return self.fetchResult.count;
    }else if (self.photos) {
        return self.photos.count;
    }
    return 0;
}

#pragma mark - Lazy
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        [_scrollView setDelegate:self];
        [_scrollView setPagingEnabled:YES];
        [_scrollView setBounces:YES];
        [_scrollView setShowsHorizontalScrollIndicator:NO];
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIImageView *)preIV
{
    if (!_preIV) {
        _preIV = [[UIImageView alloc] init];
        [self.scrollView addSubview:_preIV];
    }
    return _preIV;
}

- (UIImageView *)midIV
{
    if (!_midIV) {
        _midIV = [[UIImageView alloc] init];
        [self.scrollView addSubview:_midIV];
    }
    return _midIV;
}

- (UIImageView *)nextIV
{
    if (!_nextIV) {
        _nextIV = [[UIImageView alloc] init];
        [self.scrollView addSubview:_nextIV];
    }
    return _nextIV;
}

@end
