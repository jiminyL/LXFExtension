//
//  LXF_PhotoGrid.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PhotoGrid.h"
#import "LXF_PhotoGridCollectionViewCell.h"
#import "LXF_config.h"

#import "LXF_PhotoManager.h"

@interface LXF_PhotoGrid()<UICollectionViewDataSource, UICollectionViewDelegate>

@property CGRect previousPreheatRect;

@property (nonatomic, weak) LXF_PhotoManager *manager;

@property (nonatomic, copy) NSString *cellIdentifier;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic) BOOL didScrollToBottom;

@end

@implementation LXF_PhotoGrid

static CGSize AssetGridThumbnailSize;

- (instancetype)initWithManager:(LXF_PhotoManager *)manager
{
    if (self = [super init]) {
        self.manager = manager;
        
        self.didScrollToBottom = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self refreshViews];
}

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)refreshViews {
    [self.collectionView setFrame:self.bounds];
    [self.collectionView reloadData];
    if (!self.didScrollToBottom) {
        self.didScrollToBottom = YES;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.manager.currentFetchResult.count - 1 inSection:0] atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
        });
    }
}

#pragma mark - Data


#pragma mark - UICollectionViewDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = (self.width - 2*4)/4;
    return CGSizeMake(width, width);
}

//每个section中不同的行之间的行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

//每个item之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.manager.currentFetchResult.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LXF_PhotoGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    PHAsset *asset = self.manager.currentFetchResult[indexPath.item];
    [cell setAsset:asset];
    cell.didSelected = [self.manager.didSelectedPhotos containsObject:asset];
    __weak typeof(self) mself = self;
    cell.didChangeSeleted = ^(PHAsset * _Nonnull asset) {
        if (mself.didChangeSelected) {
            mself.didChangeSelected(asset);
        }
    };
    cell.didTouchImageView = ^(PHAsset * _Nonnull asset) {
        if (mself.didTouchImageView) {
            mself.didTouchImageView(asset, indexPath.item);
        }
    };
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // Update cached assets for the new visible area.
    if (@available(iOS 11.0, *)) {
        [self updateCachedAssets];
    }
}

#pragma mark - Asset Caching
- (void)resetCachedAssets {
    [[LXF_PhotoExtension sharedInstance].imageManager stopCachingImagesForAllAssets];
    self.previousPreheatRect = CGRectZero;
}

- (void)updateCachedAssets {
    BOOL isViewVisible = [self window] != nil;
    if (!isViewVisible) { return; }

    // The preheat window is twice the height of the visible rect.
    CGRect preheatRect = self.bounds;
    preheatRect = CGRectInset(preheatRect, 0.0f, -0.5f * CGRectGetHeight(preheatRect));

    /*
     Check if the collection view is showing an area that is significantly
     different to the last preheated area.
     */
    CGFloat delta = ABS(CGRectGetMidY(preheatRect) - CGRectGetMidY(self.previousPreheatRect));
    if (delta > CGRectGetHeight(self.bounds) / 3.0f) {

        // Compute the assets to start caching and to stop caching.
        NSMutableArray *addedIndexPaths = [NSMutableArray array];
        NSMutableArray *removedIndexPaths = [NSMutableArray array];
        __weak typeof(self) mself = self;
        [self computeDifferenceBetweenRect:self.previousPreheatRect andRect:preheatRect removedHandler:^(CGRect removedRect) {
            NSArray *indexPaths = [mself aapl_indexPathsForElementsInRect:removedRect];
            [removedIndexPaths addObjectsFromArray:indexPaths];
        } addedHandler:^(CGRect addedRect) {
            NSArray *indexPaths = [mself aapl_indexPathsForElementsInRect:addedRect];
            [addedIndexPaths addObjectsFromArray:indexPaths];
        }];

        NSArray *assetsToStartCaching = [self assetsAtIndexPaths:addedIndexPaths];
        NSArray *assetsToStopCaching = [self assetsAtIndexPaths:removedIndexPaths];

        // Update the assets the PHCachingImageManager is caching.
        [[LXF_PhotoExtension sharedInstance].imageManager startCachingImagesForAssets:assetsToStartCaching
                                                                     targetSize:AssetGridThumbnailSize
                                                                    contentMode:PHImageContentModeAspectFill
                                                                        options:nil];
        [[LXF_PhotoExtension sharedInstance].imageManager stopCachingImagesForAssets:assetsToStopCaching
                                                                    targetSize:AssetGridThumbnailSize
                                                                   contentMode:PHImageContentModeAspectFill
                                                                       options:nil];

        // Store the preheat rect to compare against in the future.
        self.previousPreheatRect = preheatRect;
    }
}

- (void)computeDifferenceBetweenRect:(CGRect)oldRect andRect:(CGRect)newRect removedHandler:(void (^)(CGRect removedRect))removedHandler addedHandler:(void (^)(CGRect addedRect))addedHandler {
    if (CGRectIntersectsRect(newRect, oldRect)) {
        CGFloat oldMaxY = CGRectGetMaxY(oldRect);
        CGFloat oldMinY = CGRectGetMinY(oldRect);
        CGFloat newMaxY = CGRectGetMaxY(newRect);
        CGFloat newMinY = CGRectGetMinY(newRect);

        if (newMaxY > oldMaxY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, oldMaxY, newRect.size.width, (newMaxY - oldMaxY));
            addedHandler(rectToAdd);
        }

        if (oldMinY > newMinY) {
            CGRect rectToAdd = CGRectMake(newRect.origin.x, newMinY, newRect.size.width, (oldMinY - newMinY));
            addedHandler(rectToAdd);
        }

        if (newMaxY < oldMaxY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, newMaxY, newRect.size.width, (oldMaxY - newMaxY));
            removedHandler(rectToRemove);
        }

        if (oldMinY < newMinY) {
            CGRect rectToRemove = CGRectMake(newRect.origin.x, oldMinY, newRect.size.width, (newMinY - oldMinY));
            removedHandler(rectToRemove);
        }
    } else {
        addedHandler(newRect);
        removedHandler(oldRect);
    }
}

- (NSArray *)assetsAtIndexPaths:(NSArray *)indexPaths {
    if (indexPaths.count == 0) { return nil; }

    NSMutableArray *assets = [NSMutableArray arrayWithCapacity:indexPaths.count];
    for (NSIndexPath *indexPath in indexPaths) {
        PHAsset *asset = self.manager.currentFetchResult[indexPath.item];
        [assets addObject:asset];
    }

    return assets;
}

- (NSArray *)aapl_indexPathsForElementsInRect:(CGRect)rect {
    NSArray *allLayoutAttributes = [self.collectionView.collectionViewLayout layoutAttributesForElementsInRect:rect];
    if (allLayoutAttributes.count == 0) { return nil; }
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:allLayoutAttributes.count];
    for (UICollectionViewLayoutAttributes *layoutAttributes in allLayoutAttributes) {
        NSIndexPath *indexPath = layoutAttributes.indexPath;
        [indexPaths addObject:indexPath];
    }
    return indexPaths;
}

#pragma mark - Lazy
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        CGFloat width = kScreenWidth / 4;
        flowLayout.itemSize = CGSizeMake(width, width);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView setBackgroundColor:[UIColor whiteColor]];
        [_collectionView setDelegate:self];
        [_collectionView setDataSource:self];
        NSString *cellIdentifier = self.cellIdentifier;
        [_collectionView registerClass:[LXF_PhotoGridCollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
        [self addSubview:_collectionView];
    }
    return _collectionView;
}

- (NSString *)cellIdentifier {
    return @"LXF_PhotoGridCollectionViewCellIdentifier";
}

@end
