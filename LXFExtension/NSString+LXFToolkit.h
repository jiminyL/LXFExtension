//
//  NSString+LXFToolkit.h
//  TestGCD
//
//  Created by 梁啸峰 on 2019/3/19.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (LXFToolkit)

NSString* strOrEmpty(NSString* str);

#pragma mark - 加密
+ (NSString*)encodeBase64String:(NSString * )input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;
- (NSString *)md5HexDigest;


#pragma mark - 计算宽高
- (CGFloat)heightForWidth:(CGFloat)width font:(UIFont *)font;
- (CGFloat)heightForWidth:(CGFloat)width font:(UIFont *)font andMinHeight:(CGFloat)minHeight;
- (CGFloat)widthForHeight:(CGFloat)height font:(UIFont *)font;

#pragma mark - 数据转换
+ (NSString *)arrayToJson:(NSArray *)array;
+ (NSString *)dictToJson:(NSDictionary *)dict;
- (id)toArrayOrNSDictionary;

- (NSString *)replaceStr:(NSString *)str withStr:(NSString *)toReplaceStr;

+ (NSString *)floatToStringTwoPoint:(CGFloat)floatValue;

@end

NS_ASSUME_NONNULL_END
