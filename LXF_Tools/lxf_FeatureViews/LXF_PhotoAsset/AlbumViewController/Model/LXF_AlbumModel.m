//
//  LXF_AlbumModel.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_AlbumModel.h"
#import <Photos/Photos.h>
#import "LXF_PhotoExtension.h"

@implementation LXF_AlbumModel

///获取缩略图
- (void)fetchThumbImage:(void (^)(UIImage *image))callback
{
    if ([self.result isKindOfClass:[PHAssetCollection class]]) {
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:self.result options:nil];
        if (assetsFetchResult.count > 0) {
            PHAsset *asset = assetsFetchResult[assetsFetchResult.count - 1];
            [[LXF_PhotoExtension sharedInstance].imageManager requestImageForAsset:asset targetSize:CGSizeMake(75.f*[UIScreen mainScreen].scale, 75.f*[UIScreen mainScreen].scale) contentMode:PHImageContentModeDefault options:[LXF_PhotoExtension sharedInstance].imageRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                self.thumbImage = result;
                callback(result);
            }];
        }else {
            callback(nil);
        }
    }else {
        callback(nil);
    }
}

@end
