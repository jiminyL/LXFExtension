//
//  LXFAlertView.h
//  KolHot
//
//  Created by 梁啸峰 on 2017/9/27.
//  Copyright © 2017年 梁啸峰. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @brief 点击回调
 *
 *  @param index 点击的下标
 */
typedef void (^CHAlertViewClickedWithIndex)(NSInteger index);
/**
 *  @brief 点击确定按钮回调
 */
typedef void (^CHAlertViewOkClicked)();
/**
 *  @brief 点击取消按钮回调
 */
typedef void (^CHAlertViewCancelClicked)();

/**
 *  @brief 弹出框
 */

@interface LXF_AlertView : NSObject

/**
 *  @brief 弹出提示框，点击返回点击下标
 *
 *  @param title           标题
 *  @param msg             提示信息
 *  @param cancelTitle     取消按钮文字
 *  @param okTitle         确定按钮文字
 *  @param otherTitleArray 其他按钮文字
 *  @param handle          点击回调
 */
+ (void)showCHAlertViewWithTitle:(NSString *)title message:(NSString *)msg cancleButtonTitle:(NSString *)cancelTitle okButtonTitle:(NSString *)okTitle otherButtonTitleArray:(NSArray*)otherTitleArray clickHandle:(CHAlertViewClickedWithIndex) handle;
/**
 *  @brief 弹出提示框只有确定和取消按钮
 *
 *  @param title             标题
 *  @param msg               提示信息
 *  @param cancelTitle       取消按钮文字
 *  @param okTitle           确定按钮文字
 *  @param okHandle          点击确定回调
 *  @param cancelClickHandle 点击取消回调
 */
+ (void)showCHAlertViewWithTitle:(NSString *)title message:(NSString *)msg cancleButtonTitle:(NSString *)cancelTitle okButtonTitle:(NSString *)okTitle okClickHandle:(CHAlertViewOkClicked)okHandle cancelClickHandle:(CHAlertViewCancelClicked)cancelClickHandle;
/**
 *  @brief 弹出框，没有回调.
 *
 *  @param title           标题
 *  @param msg             提示信息
 *  @param cancelTitle     取消按钮的文字
 *  @param okTitle         确定按钮的文字
 *  @param otherTitleArray 其他按钮文字
 */
+ (void)showCHAlertViewWithTitle:(NSString *)title message:(NSString *)msg cancleButtonTitle:(NSString *)cancelTitle okButtonTitle:(NSString *)okTitle otherButtonTitleArray:(NSArray*)otherTitleArray;

@end
