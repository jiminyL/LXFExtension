//
//  LXF_PreviewCollectionViewCell.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/6/5.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXF_PreviewCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) void (^singleTapEvent)(id asset);

@property (nonatomic, strong) id asset;

@end

NS_ASSUME_NONNULL_END
