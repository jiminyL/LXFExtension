//
//  LXF_PreviewTopBar.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/6/5.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXF_PreviewTopBar : UIView

@property (nonatomic) BOOL didSeleted;

@property (nonatomic, copy) void (^backEvent)(void);
@property (nonatomic, copy) void (^didSelectedEvent)(BOOL isAdd);

@end

NS_ASSUME_NONNULL_END
