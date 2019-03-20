//
//  APIInterface.m
//  TopicDemo
//
//  Created by PChome on 14-8-8.
//  Copyright (c) 2014年 PChome. All rights reserved.
//

#import "APIInterface.h"
#import "APIBasis.h"

#import "LXF_config.h"

@implementation APIInterface

+ (APIInterface *)sharedInstance {
	static APIInterface* sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
        
    });
	return sharedInstance;
}

- (id)init {
    self = [super init];
    if (self) {
        self.apiBase = [[APIBasis alloc] initWithMaster:self];
    }
    
    return self;
}

- (void)startAPIWithCallback:(void (^)(BOOL, NSString *))callback {
    
}

- (void)cancelAPI {

}

- (NSString *)obtainUpdatingMessage {
    return @"";
}

+ (NSMutableDictionary *)sortDictionaryWithDict:(NSDictionary *)dict
{
    NSArray* arr = [dict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    
    NSMutableDictionary *sortPara = [[NSMutableDictionary alloc] init];
    for (NSString *categoryId in arr) {
        [sortPara setObject:dict[categoryId] forKey:categoryId];
    }
    return sortPara;
}

+ (NSString *)jointDictAllKeysWithDict:(NSDictionary *)dict
{
    NSArray* arr = [dict allKeys];
    arr = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result == NSOrderedDescending;
    }];
    NSMutableArray *resultArr = [[NSMutableArray alloc] init];
    for (NSString *key in arr) {
//        //去除key为sign,signType和空的
//        if ([key isEqualToString:@"sign"] || [key isEqualToString:@"signType"] || [key isEqualToString:@""]) {
//            continue;
//        }
        //去除值为空的
//        NSString *value = dict[key];
//        if ([value isKindOfClass:[NSString class]]) {
//            if (value == nil || [value isEqualToString:@""]) {
//                continue;
//            }
//        }
        
        [resultArr addObject:[NSString stringWithFormat:@"%@=%@", key, dict[key]]];
    }
    NSString *result = [resultArr componentsJoinedByString:@"&"];
    
    return result;
}

- (NSInteger)ceilWithFloat:(double)doubleValue
{
    NSInteger result = 0;
    if (doubleValue > (long)doubleValue) {
        result = (long)doubleValue + 1;
    }else {
        result = (long)doubleValue;
    }
    return result;
}

+ (NSString *)model:(NSString *)model action:(NSString *)action
{
    NSDate *localDate = [NSDate date]; //获取当前时间
    //转换成年月日
    NSDateFormatter *fm = [[NSDateFormatter alloc]init];
    fm.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CH"];
    fm.dateFormat = @"yyyyMMdd";
    NSString *temp = [fm stringFromDate:localDate];
    //    NSDate *now = [fm dateFromString:temp];
    //
    //    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[now timeIntervalSince1970]];  //转化为UNIX时间戳
    //    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    NSString *string = [NSString stringWithFormat:@"%@%@%@99-k",model,action,temp];
    NSString *md5_str = [string md5HexDigest];
    return md5_str;
}

+ (NSString *)fetchApiTokenWithPara:(NSDictionary *)para
{
    para = [self sortDictionaryWithDict:para];
    NSString *result = [NSString stringWithFormat:@"%@appaijiancai-sdfa468aqerxcv", [self jointDictAllKeysWithDict:para]];
    return [result md5HexDigest];
}

@end
