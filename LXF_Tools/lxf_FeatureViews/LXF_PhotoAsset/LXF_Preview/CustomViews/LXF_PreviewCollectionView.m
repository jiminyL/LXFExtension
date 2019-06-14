//
//  LXF_PreviewScrollView.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/10.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PreviewCollectionView.h"
#import "LXF_PreviewCollectionViewCell.h"

#import "LXF_PreviewTopBar.h"

#import "LXF_config.h"

@interface LXF_PreviewCollectionView()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) PHFetchResult *fetchResult;
@property (nonatomic, copy) NSArray<PHAsset *> *photos;

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic) NSInteger allCount;

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) LXF_PreviewTopBar *topBar;

@property (nonatomic) BOOL fullMode;

@end

@implementation LXF_PreviewCollectionView

- (instancetype)initWithFetchResult:(PHFetchResult *)fetchResult OrPhotos:(NSArray<PHAsset *> *)photos andIndex:(NSInteger)index {
    if (self = [super init]) {
        self.fetchResult = fetchResult;
        self.photos = photos;
        _currentIndex = index;
    }
    return self;
}

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)refreshViews {
    [self.collectionView setFrame:self.bounds];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
    [self.collectionView reloadData];
    
    [self.topBar setFrame:CGRectMake(0.f, 0.f, self.width, kDevice_Is_iPhoneX ? 84.f:64.f)];
}

#pragma mark - CustomMethod
- (void)refreshTopBarState {
    PHAsset *asset;
    if (self.fetchResult) {
        asset = self.fetchResult[self.currentIndex];
    }else if (self.photos.count > 0) {
        asset = self.photos[self.currentIndex];
    }
    if (asset) {
        [self.topBar setDidSeleted:[self.manager containsAsset:asset]];
    }
}

- (void)setFullMode:(BOOL)fullMode {
    _fullMode = fullMode;
    
    [self.topBar setHidden:fullMode];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
    
    [self refreshTopBarState];
}

#pragma mark - UICollectionDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.width, self.height);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.fetchResult) {
        return self.fetchResult.count;
    }else {
        return self.photos.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LXF_PreviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LXF_PreviewCollectionViewCell" forIndexPath:indexPath];
    
    if (self.fetchResult) {
        cell.asset = self.fetchResult[indexPath.item];
    }else {
        cell.asset = self.photos[indexPath.item];
    }
    
    __weak typeof(self) mself = self;
    cell.singleTapEvent = ^(id  _Nonnull asset) {
        mself.fullMode = !mself.fullMode;
    };
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentIndex = scrollView.contentOffset.x / self.width;
}

#pragma mark - Lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        [_collectionView setBackgroundColor:[UIColor blackColor]];
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        [_collectionView setPagingEnabled:YES];
        [_collectionView setScrollsToTop:NO];
        [_collectionView setShowsHorizontalScrollIndicator:NO];
        [_collectionView registerClass:[LXF_PreviewCollectionViewCell class] forCellWithReuseIdentifier:@"LXF_PreviewCollectionViewCell"];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (LXF_PreviewTopBar *)topBar {
    if (!_topBar) {
        _topBar = [[LXF_PreviewTopBar alloc] init];
        __weak typeof(self) mself = self;
        _topBar.backEvent = ^{
            if (mself.didTouchBackEvent) {
                mself.didTouchBackEvent();
            }
        };
        _topBar.didSelectedEvent = ^(BOOL isAdd) {
            PHAsset *asset;
            if (mself.fetchResult) {
                asset = mself.fetchResult[mself.currentIndex];
            }else if (mself.photos && mself.photos.count > mself.currentIndex) {
                asset = mself.photos[mself.currentIndex];
            }
            if (asset) {
                if (isAdd) {
                    [mself.manager.didSelectedPhotos addObject:asset];
                }else {
                    [mself.manager.didSelectedPhotos removeObject:asset];
                }
                if (mself.didChangeSeleted) {
                    mself.didChangeSeleted();
                }
            }
        };
        [self addSubview:_topBar];
    }
    return _topBar;
}


@end
