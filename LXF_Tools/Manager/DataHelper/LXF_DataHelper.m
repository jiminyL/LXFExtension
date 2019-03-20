//
//  DataHelper.m
//  Drwine
//
//  Created by honestwalker on 10/8/12.
//  Copyright (c) 2012 HonestWalker. All rights reserved.
//

#import "LXF_DataHelper.h"

@implementation LXF_DataHelper

/** 将数据转换成boolean
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return BOOL 转换后的值
 */
+ (BOOL)getBoolValue:(id)object 
        defaultValue:(BOOL)defaultValue {
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
            return [object boolValue];
        }
    }
    return defaultValue;
}


/** 将数据转换成浮点数
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return CGFloat 转换后的值
 */
+ (CGFloat)getFloatValue:(id)object 
            defaultValue:(CGFloat)defaultValue {
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
            return [object floatValue];
        }
    }
    return defaultValue;
}

+ (double)getDoubleValue:(id)object
            defaultValue:(double)defaultValue {
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
            return [object doubleValue];
        }
    }
    return defaultValue;
}

/** 将数据转换成整数
 * @param   object          原数据对象
 * @param   defaultValue    默认值
 * @return NSInteger 转换后的值
 */
+ (NSInteger)getIntegerValue:(id)object 
                defaultValue:(NSInteger)defaultValue {
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSString class]] || [object isKindOfClass:[NSNumber class]]) {
            return [object integerValue];
        }
    }
    return defaultValue;
}

/** 将数据转换成数值对象
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return NSNumber 转换后的值
 */
+ (NSNumber *)getNumberValue:(id)object
                defaultValue:(NSNumber *)defaultValue {
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSNumber class]]) {
            return object;
        } else if ([object isKindOfClass:[NSString class]]) {
            return [NSNumber numberWithFloat:[object floatValue]];
        }
    }
    return defaultValue;
}

/** 将数据转换成字符串（数字将被转换成字符串）
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return NSString 转换后的值
 */
+ (NSString *)getStringValue:(id)object 
                defaultValue:(NSString *)defaultValue {
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSString class]]) {
            return object;
        } else if ([object isKindOfClass:[NSNumber class]]) {
            return [object stringValue];
        }
    }
    return defaultValue;
}

/** 将数据转换成数组
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return NSMutableArray 转换后的值
 */
+ (NSMutableArray *)getArrayValue:(id)object 
                     defaultValue:(NSMutableArray *)defaultValue {
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSMutableArray class]]) {
            return object;
        }
        if ([object isKindOfClass:[NSArray class]]) {
            return object;
        }
    }
    return defaultValue;
}

/** 将数据转换成 hashmap对象（key-value）
 * @param object        原数据对象
 * @param defaultValue  默认值
 * @return NSMutableDictionary 转换后的值
 */
+ (NSMutableDictionary *)getDictionaryValue:(id)object 
                               defaultValue:(NSMutableDictionary *)defaultValue {
    if (object && ![object isKindOfClass:[NSNull class]]) {
        if ([object isKindOfClass:[NSMutableDictionary class]]) {
            return object;
        }
        if ([object isKindOfClass:[NSDictionary class]]) {
            return object;
        }
    }
    return defaultValue;
}


@end
