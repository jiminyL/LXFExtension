//
//  LXFBrowserCollectionViewCell.m
//  KDSLife
//
//  Created by PChome on 2017/3/22.
//
//

#import "LXF_BrowserCollectionViewCell.h"

#import "LXF_config.h"

#import "UIView+LXFLayout.h"

#import "LXF_DACircularProgressView.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "LXF_FileManager.h"
#import "LXF_YLImageView.h"
#import "LXF_YLGIFImage.h"

#import "APICooperationInfo.h"

@interface LXF_BrowserCollectionViewCell()<UIGestureRecognizerDelegate,UIScrollViewDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) LXF_YLImageView *imageView;
@property (nonatomic, strong) UIView *imageContainerView;

@property (nonatomic, strong) LXF_DACircularProgressView *progress;
@property (nonatomic, strong) UIImageView *errImageView;

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *thumbStr;

@property (nonatomic) BOOL canLongPress;
@property (nonatomic) BOOL canDoubleTap;

@property (nonatomic) UIImage *image;

@end

@implementation LXF_BrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.canLongPress = YES;
        
        self.backgroundColor = [UIColor blackColor];
        self.scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
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
        
        self.imageContainerView = [[UIView alloc] init];
        _imageContainerView.clipsToBounds = YES;
        [_scrollView addSubview:_imageContainerView];
        
        _imageView = [[LXF_YLImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.clipsToBounds = YES;
        [_imageContainerView addSubview:_imageView];
        
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
        [self addGestureRecognizer:tap1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        tap2.numberOfTapsRequired = 2;
        [tap1 requireGestureRecognizerToFail:tap2];
        [self addGestureRecognizer:tap2];
        
        UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGes)];
        [self addGestureRecognizer:longGes];
    
        // Loading indicator
        self.progress = [[LXF_DACircularProgressView alloc] initWithFrame:CGRectMake((kScreenWidth - 40.f)/2, (kScreenHeight - 40.f)/2, 40.0f, 40.0f)];
        self.progress.userInteractionEnabled = NO;
        self.progress.thicknessRatio = 0.1;
        self.progress.roundedCorners = NO;
        self.progress.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin |
        UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
        [self.contentView addSubview:self.progress];

        self.errImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ImageError.png"]];
        [self.errImageView setFrame:CGRectMake((kScreenWidth - 40.f)/2, (kScreenHeight - 40.f)/2, 40.0f, 40.0f)];
        self.errImageView.hidden = YES;
        [self.contentView addSubview:self.errImageView];
    }
    return self;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    
    self.canLongPress = NO;
    self.canDoubleTap = NO;
    
    self.errImageView.hidden = YES;
    
    [_scrollView setZoomScale:1.f animated:NO];
    NSData *thumbData = UIImageJPEGRepresentation(image, 1.f);
    if (thumbData) {
        LXF_YLGIFImage *thumbImage = (LXF_YLGIFImage *)[LXF_YLGIFImage imageWithData:thumbData];
        [self.imageView setImage:thumbImage];
        [self resizeSubviews];
    }
    
    NSData *data = UIImageJPEGRepresentation(image, 1.f);
    if (data) {
        self.errImageView.hidden = YES;
        LXF_YLGIFImage *image = (LXF_YLGIFImage *)[LXF_YLGIFImage imageWithData:data];
        [self.imageView setImage:image];
        
        self.progress.hidden = YES;
        self.canLongPress = YES;
        self.canDoubleTap = YES;
        [self resizeSubviews];
    }
}

- (void)setUrlStr:(NSString *)urlStr andThumbStr:(NSString *)thumbStr
{
    self.canLongPress = NO;
    self.canDoubleTap = NO;
    
    self.urlStr = urlStr;
    self.thumbStr = thumbStr;
    
    self.errImageView.hidden = YES;
    
    [_scrollView setZoomScale:1.f animated:NO];
    NSData *thumbData = [LXF_FileManager fetchImageDataWithImageName:strOrEmpty(thumbStr)];
    if (thumbData) {
        LXF_YLGIFImage *thumbImage = (LXF_YLGIFImage *)[LXF_YLGIFImage imageWithData:thumbData];
        [self.imageView setImage:thumbImage];
        [self resizeSubviews];
    }

    NSData *data = [LXF_FileManager fetchImageDataWithImageName:strOrEmpty(urlStr)];
    if (data) {
        self.errImageView.hidden = YES;
        LXF_YLGIFImage *image = (LXF_YLGIFImage *)[LXF_YLGIFImage imageWithData:data];
        [self.imageView setImage:image];
        
        self.progress.hidden = YES;
        self.canLongPress = YES;
        self.canDoubleTap = YES;
        [self resizeSubviews];
    }else {
        self.progress.hidden = NO;
        self.progress.trackTintColor = [UIColor yellowColor];
        [[APICooperationInfo sharedInstance] fetchPhotoWithPath:strOrEmpty(urlStr) process:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            self.progress.hidden = NO;
            [self.imageContainerView bringSubviewToFront:self.progress];
            self.progress.progress = (CGFloat)((CGFloat)totalBytesRead / totalBytesExpectedToRead);
        } andCallback:^(BOOL success, id message, id responseObject) {
            self.progress.hidden = YES;
            if ([responseObject isKindOfClass:[NSData class]]) {
                self.errImageView.hidden = YES;
                NSData *resData = (NSData *)responseObject;
                [LXF_FileManager saveImageWithImageData:resData andName:urlStr];
                LXF_YLGIFImage *image = (LXF_YLGIFImage *)[LXF_YLGIFImage imageWithData:resData];
                [self.imageView setImage:image];
                
                self.canLongPress = YES;
                self.canDoubleTap = YES;

                [self resizeSubviews];
            }else {
                self.errImageView.hidden = NO;
            }
        }];
    }
}

- (void)resizeSubviews {
    _imageContainerView.tz_origin = CGPointZero;
    _imageContainerView.tz_width = self.tz_width;
    
    LXF_YLGIFImage *image = (LXF_YLGIFImage *)_imageView.image;
    
    if ((image.size.height / image.size.width) > (self.tz_height / self.tz_width)) {
        _imageContainerView.tz_height = floor(image.size.height / (image.size.width / self.tz_width));
    }else {
        CGFloat height = image.size.height / image.size.width * self.tz_width;
        if (height < 1 || isnan(height)) height = self.tz_height;
        height = floor(height);
        _imageContainerView.tz_height = height;
        _imageContainerView.tz_centerY = self.tz_height / 2;
    }
    if (_imageContainerView.tz_height > self.tz_height && _imageContainerView.tz_height - self.tz_height <= 1) {
        _imageContainerView.tz_height = self.tz_height;
    }
    if ((image.size.height / image.size.width) >= 1) {
        //竖的图片
        self.scrollView.maximumZoomScale = floor(self.tz_width / _imageContainerView.tz_width) > 2.5f ? floor(self.tz_width / _imageContainerView.tz_width) : 2.5f;
    }else {
        //横的图片
        self.scrollView.maximumZoomScale = floor(self.tz_height / _imageContainerView.tz_height) > 2.5f ? floor(self.tz_height / _imageContainerView.tz_height) : 2.5f;
    }
    _scrollView.contentSize = CGSizeMake(self.tz_width, MAX(_imageContainerView.tz_height, self.tz_height));
    [_scrollView scrollRectToVisible:self.bounds animated:NO];
    _scrollView.alwaysBounceVertical = _imageContainerView.tz_height <= self.tz_height ? NO : YES;
    _imageView.frame = _imageContainerView.bounds;
}

#pragma mark - UITapGestureRecognizer Event

- (void)singleTap:(UITapGestureRecognizer *)tap {
    if (self.singleTapGestureBlock) {
        self.singleTapGestureBlock();
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)tap {
    if (self.canDoubleTap) {
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
}

- (void)longPressGes
{
    if (!self.canLongPress) {
        return;
    }
    self.canLongPress = NO;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存", @"分享", nil];
    [actionSheet showInView:self.masterViewController.view];
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    self.canLongPress = YES;
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        if (buttonIndex == actionSheet.firstOtherButtonIndex) {
            [self savePhotoToPhotoAlbum];
        }
        if (buttonIndex == 1) {
            //分享
            [self shareToFriend];
        }
    }
}

- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    self.canLongPress = YES;
}

- (void)shareToFriend
{
    NSData *data = [LXF_FileManager fetchImageDataWithImageName:strOrEmpty(self.urlStr)];
    if (self.didShareToSocial) {
        self.didShareToSocial(data);
    }
}

- (void)savePhotoToPhotoAlbum
{
    NSData *data = [LXF_FileManager fetchImageDataWithImageName:strOrEmpty(self.urlStr)];
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageDataToSavedPhotosAlbum:data metadata:nil completionBlock:^(NSURL *assetURL, NSError *error) {
        NSString *message;
        NSString *title;
        if (!error) {
            title = @"保存成功";
            message = nil;
        } else {
            title = @"保存失败";
            message = [error description];
        }
            
        [self.masterViewController.view hideToastActivity];
        [self.masterViewController.view makeToast:title duration:2.f position:@"center" title:message];
    }];

    [self.masterViewController.view makeToastActivity];
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

@end
