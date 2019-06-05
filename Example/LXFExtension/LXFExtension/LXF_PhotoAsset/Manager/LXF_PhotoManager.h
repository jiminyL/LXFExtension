//
//  LXF_PhotoManager.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/10.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LXF_PhotoExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXF_PhotoManager : NSObject

@property (nonatomic, strong) NSMutableArray<PHAsset *> *didSelectedPhotos;
@property (nonatomic, strong) PHAssetCollection *currentCollection;
@property (nonatomic, strong) PHFetchResult *currentFetchResult;

@end


NS_ASSUME_NONNULL_END
