//
//  LXF_config.h
//  TestGCD
//
//  Created by 梁啸峰 on 2019/3/19.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#ifndef LXF_config_h
#define LXF_config_h

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "UIView+LXFSizes.h"
#import "UIView+LXFToast.h"
#import "LXF_Common.h"
#import "NSString+LXFToolkit.h"
#import "UIColor+LXFToolkit.h"
#import "UIImage+LXFToolkit.h"
#import "LXF_DataHelper.h"

#define isIOS7OrLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.f)
#define isIOS11OrLater ([[[UIDevice currentDevice] systemVersion] floatValue] >= 11.f)


#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight ([[UIScreen mainScreen] bounds].size.height - (IS_HOTSPOT_CONNECTED ? 40.f : 0.f))
#define kScreenHeightOrg [[UIScreen mainScreen] bounds].size.height


#define SYS_STATUSBAR_HEIGHT            20
#define APP_STATUSBAR_HEIGHT            [UIApplication sharedApplication].statusBarFrame.size.height
#define HOTSPOT_STATUSBAR_HEIGHT        20
#define IS_HOTSPOT_CONNECTED            kDevice_Is_iPhoneX ? NO : (APP_STATUSBAR_HEIGHT==(SYS_STATUSBAR_HEIGHT+HOTSPOT_STATUSBAR_HEIGHT)?YES:NO)

#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kStatusBarHeight (kDevice_Is_iPhoneX ? ([UIApplication sharedApplication].statusBarFrame.size.height == 64.f ? 44.f : [UIApplication sharedApplication].statusBarFrame.size.height) : (IS_HOTSPOT_CONNECTED ? 0.f : [UIApplication sharedApplication].statusBarFrame.size.height))

#define kStatus_Bar_Bigger_than_20 [UIApplication sharedApplication].statusBarFrame.size.height > 20


#endif /* LXF_config_h */
