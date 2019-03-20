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

typedef enum {
    CodeStateOK                                                 = 200,
    CodeStateToLogin                                            = -10000,
    CodeStateNoUnion                                            = 404
} CodeState;

@property (nonatomic, retain) APIBasis *apiBase;

+ (APIInterface *)sharedInstance;

- (id)init;

- (void)startAPIWithCallback:(void (^)(BOOL success, NSString *message))callback;

- (void)cancelAPI;

- (NSString *)obtainUpdatingMessage;

- (NSMutableDictionary *)sortDictionaryWithDict:(NSDictionary *)dict;

- (NSString *)jointDictAllKeysWithDict:(NSDictionary *)dict;

- (NSInteger)ceilWithFloat:(double)doubleValue;

+ (NSString *)model:(NSString *)model action:(NSString *)action;

+ (NSString *)fetchApiTokenWithPara:(NSDictionary *)para;

@end
