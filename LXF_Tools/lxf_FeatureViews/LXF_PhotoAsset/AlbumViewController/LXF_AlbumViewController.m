//
//  LXF_AlbumViewController.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_AlbumViewController.h"
#import "LXF_PhotoGridViewController.h"

#import "LXF_AlbumList.h"

@interface LXF_AlbumViewController ()<PHPhotoLibraryChangeObserver>

@property (nonatomic, strong) LXF_AlbumList *albumList;

@end

@implementation LXF_AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"相册";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backButtonEvent)];
    
    [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
}

- (void)viewWillLayoutSubviews {
    [self refreshViews];
}

- (void)refreshViews {
    [self.albumList setFrame:self.view.bounds];
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshViews];
    });
}

#pragma mark - ButtonEvent
- (void)backButtonEvent {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)albumEvent:(LXF_AlbumModel *)album {
    self.manager.currentCollection = album.result;
    LXF_PhotoGridViewController *vc = [[LXF_PhotoGridViewController alloc] initWithManager:self.manager];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Lazy
- (LXF_AlbumList *)albumList {
    if (!_albumList) {
        __weak typeof(self) mself = self;
        _albumList = [[LXF_AlbumList alloc] init];
        _albumList.didTouchAlbum = ^(LXF_AlbumModel * _Nonnull album) {
            [mself albumEvent:album];
        };
        [self.view addSubview:_albumList];
    }
    return _albumList;
}

@end
