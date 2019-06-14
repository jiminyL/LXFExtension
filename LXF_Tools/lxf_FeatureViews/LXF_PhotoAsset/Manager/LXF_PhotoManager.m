//
//  LXF_PhotoManager.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/10.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PhotoManager.h"
#import "LXF_PhotoAssetNavigationController.h"

@interface LXF_PhotoManager()

@property (nonatomic, weak) UIViewController *masterViewController;

@end


@implementation LXF_PhotoManager

- (instancetype)initWithMasterViewController:(UIViewController *)masterViewController {
    if (self = [super init]) {
        self.masterViewController = masterViewController;
    }
    return self;
}

- (void)show {
    LXF_PhotoAssetNavigationController *vc = [[LXF_PhotoAssetNavigationController alloc] initWithManager:self];
    [self.masterViewController presentViewController:vc animated:YES completion:nil];
}

- (void)dismiss {
    if (self.didSelectedPhotos.count > 0) {
        if (self.doneEvent) {
            self.doneEvent(self.didSelectedPhotos);
        }
    }
}

- (NSMutableArray<PHAsset *> *)didSelectedPhotos {
    if (!_didSelectedPhotos) {
        _didSelectedPhotos = [[NSMutableArray alloc] init];
    }
    return _didSelectedPhotos;
}

- (BOOL)containsAsset:(PHAsset *)asset {
    for (PHAsset *tmpAsset in self.didSelectedPhotos) {
        if (tmpAsset == asset) {
            return YES;
        }
    }
    return NO;
}


@end
