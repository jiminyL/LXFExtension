//
//  NSDate+SSTooKitAddtions.h
//  KdsSoftHD
//
//  Created by PChome on 14-7-23.
//  Copyright (c) 2014年 PCHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LXFTooKit)

+ (NSDate *)localDateWithDate:(NSDate *)date;

+ (NSDate*)convertDateFromString:(NSString*)uiDate;
+ (NSDate *)converDateFromString2:(NSString *)uiDate;
+ (NSDate *)converDateFromString3:(NSString *)uiDate;
+ (NSDate *)converDateFromString4:(NSString *)uiDate;

+ (NSString *)dateToStrStyle1WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle2WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle3WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle4WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle5WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle6WithDate:(NSDate *)date;
+ (NSString *)dateToStrStyle7WithDate:(NSDate *)date;
+ (NSString *)dateToStrSeasonStyleWithDate:(NSDate *)date;

+ (NSString *)dateToStrWithStartDate:(NSDate *)startDate andEndDate:(NSDate *)endDate;

//通过时间戳转换时间字符串
+ (NSString *)timeStrWithUnixTimeStamp:(NSInteger)unixTime;

///获取一个月前的NSDate
+ (NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(int)month;

@end
