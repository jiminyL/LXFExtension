//
//  APIBase.h
//  TopicDemo
//
//  Created by PChome on 14-8-8.
//  Copyright (c) 2014年 PChome. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AFNetworking.h"

@interface APIBasis : NSObject

@property (strong, nonatomic) IBOutlet id master;

@property (nonatomic, strong) NSMutableDictionary *basePara;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;

- (id)initWithMaster:(id)master;
- (void)setupBaseURL:(NSURL *)baseURL;

- (void)getPhotoPath:(NSString *)path
             process:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))process
          completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback;

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters timeOut:(CGFloat)timeOut completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback;

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback;

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback;

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters attachFiles:(void (^)(id <AFMultipartFormData> formData))bodyConstructBlock uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback;

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method
                                     path:(NSString *)path;

//- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters timeOut:(CGFloat)timeOut completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback;
//
//- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback;
//
//- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback;
//
//- (void)deletePath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback;
//
//- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters attachFiles:(void (^)(id <AFMultipartFormData> formData))bodyConstructBlock uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock completion:(void (^)(AFJSONRequestOperation *operation, id JSONObject, NSError *error))callback;

+ (void)changeCurrentBaseURLIndex;
+ (NSString *)currentBaseURL;

@end
