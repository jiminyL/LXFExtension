//
//  LXF_PhotoGridCollectionViewCell.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXF_PhotoExtension.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXF_PhotoGridCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^didTouchImageView)(PHAsset *asset);
@property (nonatomic, copy) void (^didChangeSeleted)(PHAsset *asset);

@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic) BOOL didSelected;

@end

NS_ASSUME_NONNULL_END
