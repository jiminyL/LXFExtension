//
//  LXF_PhotoGridViewController.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PhotoGridViewController.h"
#import "LXF_PreviewViewController.h"

#import "LXF_PhotoGrid.h"

@interface LXF_PhotoGridViewController ()

@property (nonatomic, weak) LXF_PhotoManager *manager;

@property (nonatomic, strong) LXF_PhotoGrid *photoGrid;

@end

@implementation LXF_PhotoGridViewController

- (instancetype)initWithManager:(LXF_PhotoManager *)manager
{
    if (self = [super init]) {
        self.manager = manager;
        
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
//        options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d OR mediaType = %d",PHAssetMediaTypeImage, PHAssetMediaTypeVideo];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d",PHAssetMediaTypeImage];
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:manager.currentCollection options:options];
        
        self.manager.currentFetchResult = assetsFetchResult;
        
        self.title = manager.currentCollection.localizedTitle;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self refreshViews];
}

- (void)viewDidLayoutSubviews
{
    [self refreshViews];
}

- (void)refreshViews
{
    [self.photoGrid setFrame:self.view.bounds];
}

#pragma mark - Event
- (void)touchPhotoWithIndex:(NSInteger)index {
    LXF_PreviewViewController *vc = [[LXF_PreviewViewController alloc] initWithFetchResult:self.manager.currentFetchResult OrPhotos:nil andIndex:index];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark -
- (LXF_PhotoGrid *)photoGrid
{
    if (!_photoGrid) {
        _photoGrid = [[LXF_PhotoGrid alloc] initWithManager:self.manager];
        __weak typeof(self) mself = self;
        _photoGrid.didChangeSelected = ^(PHAsset * _Nonnull asset) {
            if ([mself.manager.didSelectedPhotos containsObject:asset]) {
                [mself.manager.didSelectedPhotos removeObject:asset];
            }else {
                [mself.manager.didSelectedPhotos addObject:asset];
            }
        };
        _photoGrid.didTouchImageView = ^(PHAsset * _Nonnull asset, NSInteger index) {
            [mself touchPhotoWithIndex:index];
        };
        [self.view addSubview:_photoGrid];
    }
    return _photoGrid;
}


@end
