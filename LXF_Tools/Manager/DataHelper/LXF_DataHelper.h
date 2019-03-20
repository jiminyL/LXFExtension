//
//  DataHelper.h
//  Drwine
//
//  Created by honestwalker on 10/8/12.
//  Copyright (c) 2012 HonestWalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LXF_DataHelper : NSObject

/** 将数据转换成boolean
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return BOOL 转换后的值
 */
+ (BOOL)getBoolValue:(id)object
        defaultValue:(BOOL)defaultValue;

+ (CGFloat)getFloatValue:(id)objec
            defaultValue:(CGFloat)defaultValue;

/** 将数据转换成双精度浮点数
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return double 转换后的值
 */
+ (double)getDoubleValue:(id)object
            defaultValue:(double)defaultValue;

/** 将数据转换成整数
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return NSInteger    转换后的值
 */
+ (NSInteger)getIntegerValue:(id)object
                defaultValue:(NSInteger)defaultValue;

/** 将数据转换成数值对象
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return NSNumber     转换后的值
 */
+ (NSNumber *)getNumberValue:(id)object
                defaultValue:(NSNumber *)defaultValue;

/** 将数据转换成字符串（数字将被转换成字符串）
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return NSString     转换后的值
 */
+ (NSString *)getStringValue:(id)object 
                defaultValue:(NSString *)defaultValue;

/** 将数据转换成数组
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return NSMutableArray 转换后的值
 */
+ (NSMutableArray *)getArrayValue:(id)object
                     defaultValue:(NSMutableArray *)defaultValue;

/** 将数据转换成 hashmap对象（key-value）
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return NSMutableDictionary 转换后的值
 */
+ (NSMutableDictionary *)getDictionaryValue:(id)object 
                               defaultValue:(NSMutableDictionary *)defaultValue;

@end
