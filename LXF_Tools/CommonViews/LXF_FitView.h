//
//  LXF_FitView.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/3/26.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>

CGFloat const HEIGHT_TO_Fit     =       -1;
CGFloat const WIDTH_TO_Fit      =       -1;

NS_ASSUME_NONNULL_BEGIN

@interface LXF_FitView : UIView

@property (nonatomic) CGFloat content_width;
@property (nonatomic) CGFloat content_height;

@end

NS_ASSUME_NONNULL_END
