//
//  LXF_PhotoGrid.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXF_PhotoManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXF_PhotoGrid : UIView

@property (nonatomic, copy) void (^didTouchImageView)(PHAsset *asset, NSInteger index);
@property (nonatomic, copy) void (^didChangeSelected)(PHAsset *asset);

- (instancetype)initWithManager:(LXF_PhotoManager *)manager;


@end

NS_ASSUME_NONNULL_END
