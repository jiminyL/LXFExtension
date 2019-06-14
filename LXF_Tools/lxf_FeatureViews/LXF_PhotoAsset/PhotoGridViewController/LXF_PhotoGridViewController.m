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
#import "LXF_PGBottomView.h"

@interface LXF_PhotoGridViewController ()

@property (nonatomic, weak) LXF_PhotoManager *manager;

@property (nonatomic, strong) LXF_PhotoGrid *photoGrid;
@property (nonatomic, strong) LXF_PGBottomView *bottomView;

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
    
    [self configNaviBar];
    
    [self refreshViews];
}

- (void)configNaviBar {
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonEvent)];
    self.navigationItem.rightBarButtonItem = cancel;
}

- (void)viewDidLayoutSubviews
{
    [self refreshViews];
}

- (void)refreshViews
{
    CGFloat bottomHeight = [LXF_PGBottomView height];
    
    [self.photoGrid setFrame:CGRectMake(0.f, 0.f, self.view.width, self.view.height - bottomHeight)];
    
    [self.bottomView setFrame:CGRectMake(0.f, self.view.height - bottomHeight, self.view.width, bottomHeight)];
}

#pragma mark - Event
- (void)cancelButtonEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)touchPhotoWithIndex:(NSInteger)index {
    LXF_PreviewViewController *vc = [[LXF_PreviewViewController alloc] initWithFetchResult:self.manager.currentFetchResult OrPhotos:nil andIndex:index];
    __weak typeof(self) mself = self;
    vc.didChangeSeleted = ^{
        [mself.photoGrid reloadData];
        [mself.bottomView setCount:mself.manager.didSelectedPhotos.count];
    };
    vc.manager = self.manager;
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
            [mself.bottomView setCount:mself.manager.didSelectedPhotos.count];
        };
        _photoGrid.didTouchImageView = ^(PHAsset * _Nonnull asset, NSInteger index) {
            [mself touchPhotoWithIndex:index];
        };
        [self.view addSubview:_photoGrid];
    }
    return _photoGrid;
}

- (LXF_PGBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[LXF_PGBottomView alloc] init];
        __weak typeof(self) mself = self;
        _bottomView.didTouchDoneButtonEvent = ^{
            [mself.manager dismiss];
            [mself dismissViewControllerAnimated:YES completion:nil];
        };
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}

@end
