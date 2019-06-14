//
//  LXF_PGBottomView.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/6/5.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXF_PGBottomView : UIView

@property (nonatomic, copy) void (^didTouchDoneButtonEvent)(void);

@property (nonatomic) NSInteger count;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
