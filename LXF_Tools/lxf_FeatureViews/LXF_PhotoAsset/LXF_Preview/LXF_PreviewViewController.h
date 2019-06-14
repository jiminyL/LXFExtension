//
//  LXF_PreviewViewController.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/10.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXF_PhotoManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXF_PreviewViewController : UIViewController

@property (nonatomic, copy) void (^didChangeSeleted)(void);

@property (nonatomic, weak) LXF_PhotoManager *manager;

- (instancetype)initWithFetchResult:(PHFetchResult *)fetchResult OrPhotos:(nullable NSArray<PHAsset *> *)photos andIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
