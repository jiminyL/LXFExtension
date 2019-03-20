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


@end
