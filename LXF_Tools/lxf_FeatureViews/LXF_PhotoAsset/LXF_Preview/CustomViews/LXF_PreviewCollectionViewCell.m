//
//  LXF_PreviewCollectionViewCell.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/6/5.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PreviewCollectionViewCell.h"
#import "LXF_config.h"
#import "LXF_YLImageView.h"

#import "LXF_PhotoExtension.h"
#import <Photos/Photos.h>

@interface LXF_PreviewCollectionViewCell()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *imageContainerView;
@property (nonatomic, strong) LXF_YLImageView *imageView;

@end

@implementation LXF_PreviewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
    }
    return self;
}

- (void)setAsset:(id)asset {
    _asset = asset;
    
    [self refreshViews];
}

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)refreshViews {
    [self.scrollView setFrame:self.bounds];
    [self.scrollView setZoomScale:1.f animated:NO];
    
    if ([self.asset isKindOfClass:[PHAsset class]]) {
        PHAsset *phAsset = (PHAsset *)self.asset;
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//            [[LXF_PhotoExtension sharedInstance].imageManager requestImageDataForAsset:phAsset options:[LXF_PhotoExtension sharedInstance].imageThumRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    LXF_YLGIFImage *image = (LXF_YLGIFImage *)[LXF_YLGIFImage imageWithData:imageData];
//                    self.imageView.image = image;
//
//                    [self resizeSubviews];
//                });
//            }];
//        });
        CGFloat photoWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
        CGFloat multiple = [UIScreen mainScreen].scale;
        CGFloat pixelWidth = photoWidth * multiple;
        CGFloat pixelHeight = pixelWidth / aspectRatio;
        
        PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
        option.resizeMode = PHImageRequestOptionsResizeModeFast;
        
        [[PHImageManager defaultManager] requestImageForAsset:phAsset targetSize:CGSizeMake(pixelWidth, pixelHeight) contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (downloadFinined) {
                if (result != nil) {
                    self.imageView.image = result;
                    [self resizeSubviews];
                }
            }
        }];

        
    }else if ([self.asset isKindOfClass:[NSData class]]) {
        LXF_YLGIFImage *image = (LXF_YLGIFImage *)[LXF_YLGIFImage imageWithData:self.asset];
        self.imageView.image = image;
        [self resizeSubviews];
    }else if ([self.asset isKindOfClass:[UIImage class]]) {
        self.imageView.image = self.asset;
        [self resizeSubviews];
    }
}

- (void)resizeSubviews {
    _imageContainerView.origin = CGPointZero;
    _imageContainerView.width = self.width;
    
    UIImage *image = _imageView.image;
    if (image.size.height / image.size.width > self.height / self.width) {
        _imageContainerView.height = floor(image.size.height / (image.size.width / self.width));
    } else {
        CGFloat height = image.size.height / image.size.width * self.width;
        if (height < 1 || isnan(height)) height = self.height;
        height = floor(height);
        _imageContainerView.height = height;
        _imageContainerView.centerY = self.height / 2;
    }
    if (_imageContainerView.height > self.height && _imageContainerView.height - self.height <= 1) {
        _imageContainerView.height = self.height;
    }
    _scrollView.contentSize = CGSizeMake(self.width, MAX(_imageContainerView.height, self.height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.height <= self.height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - Event
- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapEvent) {
        self.singleTapEvent(self.asset);
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (_scrollView.zoomScale > 1.0) {
        [_scrollView setZoomScale:1.0 animated:YES];
    } else {
        CGPoint touchPoint = [tap locationInView:self.imageView];
        CGFloat newZoomScale = _scrollView.maximumZoomScale;
        CGFloat xsize = self.frame.size.width / newZoomScale;
        CGFloat ysize = self.frame.size.height / newZoomScale;
        [_scrollView zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageContainerView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.frame.size.width > scrollView.contentSize.width) ? (scrollView.frame.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.frame.size.height > scrollView.contentSize.height) ? (scrollView.frame.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageContainerView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
}

#pragma mark - Lazy
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.bouncesZoom = YES;
        _scrollView.maximumZoomScale = 2.5;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
        _scrollView.canCancelContentTouches = YES;
        _scrollView.alwaysBounceVertical = NO;
        [self.contentView addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)imageContainerView {
    if (!_imageContainerView) {
        _imageContainerView = [[UIView alloc] init];
        [_imageContainerView setClipsToBounds:YES];
        [self.scrollView addSubview:_imageContainerView];
    }
    return _imageContainerView;
}

- (LXF_YLImageView *)imageView {
    if (!_imageView) {
        _imageView = [[LXF_YLImageView alloc] init];
        [_imageView setBackgroundColor:[UIColor colorWithWhite:1.f alpha:0.5f]];
        [_imageView setClipsToBounds:YES];
        [self.imageContainerView addSubview:self.imageView];
    }
    return _imageView;
}

@end
