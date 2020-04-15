//
//  NSString+LXFToolkit.m
//  TestGCD
//
//  Created by 梁啸峰 on 2019/3/19.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "NSString+LXFToolkit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (LXFToolkit)

NSString* strOrEmpty(NSString* str) {
    if ([str isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",str];
    }
    return (str == nil || [str isKindOfClass:[NSNull class]] ? @"" : str);
}

#pragma mark - 加密
+ (NSString*)encodeBase64String:(NSString * )input {
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    data = [data base64EncodedDataWithOptions:0];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64String:(NSString *)input {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:strOrEmpty(input) options:0];
    if (data) {
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return nil;
}

+ (NSString*)encodeBase64Data:(NSData *)data {
    data = [data base64EncodedDataWithOptions:0];
    NSString *base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return base64String;
}

+ (NSString*)decodeBase64Data:(NSData *)data {
    if (data) {
        NSString *base64Str = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSData *baset64Data = [[NSData alloc] initWithBase64EncodedString:strOrEmpty(base64Str) options:0];
        if (baset64Data) {
            NSString *result = [[NSString alloc] initWithData:baset64Data encoding:NSUTF8StringEncoding];
            return strOrEmpty(result);
        }
    }
    return nil;
}

-(NSString *)md5HexDigest
{
    const char *original_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

#pragma mark - 计算宽高
- (CGFloat)heightForWidth:(CGFloat)width
                     font:(UIFont *)font
{
    CGRect textSize;
    if (self != nil && ![self isEqualToString:@""]) {
        NSAttributedString *attributedTest = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
        textSize = [attributedTest boundingRectWithSize:(CGSize){width, CGFLOAT_MAX}
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                context:nil];
        return textSize.size.height;
    }
    
    return 0.f;
}

- (CGFloat)heightForWidth:(CGFloat)width
                     font:(UIFont *)font
             andMinHeight:(CGFloat)minHeight
{
    CGFloat resultHeight = [self heightForWidth:width font:font];
    resultHeight = resultHeight > minHeight ? resultHeight : minHeight;
    return resultHeight;
}

- (CGFloat)widthForHeight:(CGFloat)height
                     font:(UIFont *)font
{
    CGRect textSize;
    if (self != nil && ![self isEqualToString:@""]) {
        NSAttributedString *attributedTest = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
        textSize = [attributedTest boundingRectWithSize:(CGSize){CGFLOAT_MAX, height}
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                context:nil];
        return textSize.size.width;
    }
    
    return 0.f;
}

#pragma mark - 数据转换
+ (NSString *)arrayToJson:(NSArray *)array
{
    if (array) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        if ([jsonData length] > 0 && error == nil){
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            return jsonString;
        }else{
            return nil;
        }
    }else {
        return nil;
    }
}

+ (NSString *)dictToJson:(NSDictionary *)dict
{
    if (dict) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        
        if ([jsonData length] > 0 && error == nil){
            NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                         encoding:NSUTF8StringEncoding];
            return jsonString;
        }else{
            return nil;
        }
    }else {
        return nil;
    }
}

- (id)toArrayOrNSDictionary
{
    NSData *jsonData = [self dataUsingEncoding:NSASCIIStringEncoding];
    
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    
    if (jsonObject != nil && error == nil){
        return jsonObject;
    }else{
        // 解析错误
        return nil;
    }
}

- (NSString *)replaceStr:(NSString *)str withStr:(NSString *)toReplaceStr
{
    NSRange range = [self rangeOfString:str];
    if (range.location == NSNotFound || range.length == NSNotFound) {
        return self;
    }else {
        NSMutableString *resultStr = [NSMutableString stringWithString:self];
        [resultStr replaceCharactersInRange:range withString:toReplaceStr];
        return [resultStr replaceStr:str withStr:toReplaceStr];
    }
}

+ (NSString *)floatToStringTwoPoint:(CGFloat)floatValue
{
    if (floatValue == NSNotFound) {
        return @"-";
    }
    NSString *temp = [NSString stringWithFormat:@"%.2f", floatValue];
    floatValue = temp.floatValue;
    if (fmodf(floatValue, 1) == 0) {
        return [NSString stringWithFormat:@"%.0f", floatValue];
    }else if (fmodf(floatValue*10, 1) == 0) {
        return [NSString stringWithFormat:@"%.1f", floatValue];
    }else {
        return [NSString stringWithFormat:@"%.2f", floatValue];
    }
}

@end
