//
//  LXFBannerView.h
//  TestBannerView
//
//  Created by 梁啸峰 on 2019/3/1.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXFBannerModel;

NS_ASSUME_NONNULL_BEGIN

@interface LXF_BannerView : UIView

@property (nonatomic, copy) void (^didTouchEvent)(LXFBannerModel *bannerModel);

@property (nonatomic, copy) NSArray<LXFBannerModel *> *bannerModelArr;

@property (nonatomic) NSInteger currentIndex;

@end

//Model -----------------------------------------------
@interface LXFBannerModel : NSObject

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageUrl;

@property (nonatomic, weak) id sender;

@end

NS_ASSUME_NONNULL_END
