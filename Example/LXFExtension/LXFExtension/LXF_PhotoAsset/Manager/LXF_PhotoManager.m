//
//  LXF_PhotoManager.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/10.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PhotoManager.h"

@implementation LXF_PhotoManager

- (NSMutableArray<PHAsset *> *)didSelectedPhotos
{
    if (!_didSelectedPhotos) {
        _didSelectedPhotos = [[NSMutableArray alloc] init];
    }
    return _didSelectedPhotos;
}


@end
