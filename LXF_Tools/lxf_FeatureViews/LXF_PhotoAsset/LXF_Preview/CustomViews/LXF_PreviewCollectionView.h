//
//  LXF_PreviewScrollView.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/10.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXF_PhotoManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXF_PreviewCollectionView : UIView

@property (nonatomic, weak) LXF_PhotoManager *manager;

@property (nonatomic, copy) void (^didChangeSeleted)(void);
@property (nonatomic, copy) void (^didTouchBackEvent)(void);

- (instancetype)initWithFetchResult:(PHFetchResult *)fetchResult OrPhotos:(NSArray<PHAsset *> *)photos andIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
