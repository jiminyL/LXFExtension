//
//  APIInterface.h
//  TopicDemo
//
//  Created by PChome on 14-8-8.
//  Copyright (c) 2014年 PChome. All rights reserved.
//

//#import "AFHTTPClient.h"

#import "LXF_config.h"

@class APIBasis;

//@interface APIInterface : AFHTTPClient
@interface APIInterface : NSObject

@property (nonatomic, retain) APIBasis *apiBase;

+ (APIInterface *)sharedInstance;

- (id)init;

+ (NSMutableDictionary *)sortDictionaryWithDict:(NSDictionary *)dict;

+ (NSString *)jointDictAllKeysWithDict:(NSDictionary *)dict;

- (NSInteger)ceilWithFloat:(double)doubleValue;

@end
