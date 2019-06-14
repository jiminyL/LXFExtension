//
//  LXF_PreviewViewController.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/10.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PreviewViewController.h"

#import "LXF_PreviewCollectionView.h"

@interface LXF_PreviewViewController ()

@property (nonatomic, strong) LXF_PreviewCollectionView *scrollView;

@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, copy) NSArray<PHAsset *> *photos;
@property (nonatomic) NSInteger currentIndex;

@end

@implementation LXF_PreviewViewController

- (instancetype)initWithFetchResult:(PHFetchResult *)fetchResult OrPhotos:(nullable NSArray<PHAsset *> *)photos andIndex:(NSInteger)index {
    if (self = [super init]) {
        self.fetchResult = fetchResult;
        self.photos = photos;
        self.currentIndex = index;
    }
    return self;
}

- (void)setManager:(LXF_PhotoManager *)manager {
    _manager = manager;
    self.scrollView.manager = _manager;
    
    [self refreshViews];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES];
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *firstV = [[UIView alloc] init];
    [self.view addSubview:firstV];
    
    [self refreshViews];
}

- (void)viewDidLayoutSubviews {
    [self refreshViews];
}

- (void)refreshViews {
    [self.scrollView setFrame:self.view.bounds];
}

#pragma mark - Event
- (void)backEvent {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Lazy
- (LXF_PreviewCollectionView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[LXF_PreviewCollectionView alloc] initWithFetchResult:self.fetchResult OrPhotos:self.photos andIndex:self.currentIndex];
        __weak typeof(self) mself = self;
        _scrollView.didTouchBackEvent = ^{
            [mself backEvent];
        };
        _scrollView.didChangeSeleted = ^{
            if (mself.didChangeSeleted) {
                mself.didChangeSeleted();
            }
        };
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

@end
