//
//  APIBase.m
//  TopicDemo
//
//  Created by PChome on 14-8-8.
//  Copyright (c) 2014年 PChome. All rights reserved.
//

#import "APIBasis.h"
#import "OpenUDID.h"

#import "LXF_config.h"

#define kBaseURL @""

@interface APIBasis()

@property (readwrite, nonatomic, strong) NSURLCredential *defaultCredential;

@end

@implementation APIBasis

- (void)setupBaseURL:(NSURL *)baseURL
{
    self.manager.baseURL = baseURL;
}

- (id)initWithMaster:(id)master {
    self = [super init];
    if (self) {
        self.master = master;
        self.manager = [AFHTTPRequestOperationManager manager];
        
        self.basePara = [[NSMutableDictionary alloc] init];
        [self.basePara setObject:@"1" forKey:@"encrypt"];
        [self.basePara setObject:@"iphone" forKey:@"system"];
        
        [self.basePara setObject:strOrEmpty([[LXF_Common sharedInstance] getDeviceVersionInfo]) forKey:@"device_model"];
        
        [self.basePara setObject:strOrEmpty([OpenUDID value]) forKey:@"device_id"];
        
        [self.basePara setObject:strOrEmpty([[LXF_Common sharedInstance] getDeviceCustomName]) forKey:@"phone_name"];
        
        NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
        [self.basePara setObject:strOrEmpty(systemVersion) forKey:@"system_version"];
        
        NSDictionary* infoDict = [[NSBundle mainBundle] infoDictionary];
        NSString* versionNum = [infoDict objectForKey:@"CFBundleShortVersionString"];
        [self.basePara setObject:strOrEmpty(versionNum) forKey:@"appver"];
        
        NSString *buildVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        [self.basePara setObject:strOrEmpty(buildVersion) forKey:@"build_version"];
    }
    return self;
}

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters timeOut:(CGFloat)timeOut completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback
{
    [self getPath:path parameters:parameters timeOut:timeOut andStartIndex:1 completion:callback];
}

- (void)getPhotoPath:(NSString *)path
             process:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))process
          completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback
{
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:path]]];
    operation.inputStream   = [NSInputStream inputStreamWithURL:[NSURL URLWithString:path]];
//    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        process(bytesRead, totalBytesRead, totalBytesExpectedToRead);
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        callback(operation, responseObject, nil);
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        callback(operation, nil, error);
    }];
    
    [operation start];
}

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters timeOut:(CGFloat)timeOut andStartIndex:(NSInteger)startIndex completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback
{
    AFHTTPRequestOperation *op;
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    op = [self.manager GET:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (([responseObject class] == [NSDictionary class]) || ([responseObject class] == [NSArray class])) {
            callback(op , responseObject, nil);
        }else {
            NSData *data = (NSData *)responseObject;
            NSError *error;
            id resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (([resultDic isKindOfClass:[NSDictionary class]]) || ([resultDic isKindOfClass:[NSArray class]])) {
                callback(op, resultDic, nil);
            }else {
                NSString *jsonStr = [NSString decodeBase64Data:data];
                
                id result = [jsonStr toArrayOrNSDictionary];
                callback(op, result, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (error) {
            [APIBasis changeCurrentBaseURLIndex];
        }
        if (startIndex < 4) {
            [self getPath:path parameters:parameters timeOut:timeOut andStartIndex:(startIndex+1) completion:^(AFHTTPRequestOperation *operation, id JSONObject, NSError *error) {
                callback(operation, JSONObject, error);
            }];
        }else {
            callback(op, nil, error);
        }
    }];
}

- (void)getPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback
{
    [self getPath:path parameters:parameters andStartIndex:1 completion:callback];
}

- (void)getPath:(NSString *)path
     parameters:(NSDictionary *)parameters
  andStartIndex:(NSInteger)startIndex
     completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback
{
    AFHTTPRequestOperation *op;
    
    CGFloat timeout = 30.f;
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self.manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    self.manager.requestSerializer.timeoutInterval = timeout;
    [self.manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    op = [self.manager GET:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (([responseObject class] == [NSDictionary class]) || ([responseObject class] == [NSArray class])) {
            callback(op , responseObject, nil);
        }else {
            NSData *data = (NSData *)responseObject;
            NSError *error;
            id resultDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (([resultDic isKindOfClass:[NSDictionary class]]) || ([resultDic isKindOfClass:[NSArray class]])) {
                callback(op, resultDic, nil);
            }else {
                NSString *jsonStr = [NSString decodeBase64Data:data];
                
                id result = [jsonStr toArrayOrNSDictionary];
                if (([result isKindOfClass:[NSDictionary class]]) || ([resultDic isKindOfClass:[NSArray class]])) {
                    callback(op, result, nil);
                }else {
                    callback(op, responseObject, nil);
                }
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (error) {
            [APIBasis changeCurrentBaseURLIndex];
        }
        if (startIndex < 4) {
            [self getPath:path parameters:parameters andStartIndex:(startIndex+1) completion:^(AFHTTPRequestOperation *operation, id JSONObject, NSError *error) {
                callback(operation, JSONObject, error);
            }];
        }else {
            callback(op, nil, error);
        }
    }];
}

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback
{
    [self postPath:path parameters:parameters andStartIndex:1 completion:callback];
}

- (void)postPath:(NSString *)path
      parameters:(NSDictionary *)parameters
   andStartIndex:(NSInteger)startIndex
      completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback
{
    AFHTTPRequestOperation *op;
    
    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    op = [self.manager POST:path parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (([responseObject isKindOfClass:[NSDictionary class]]) || ([responseObject isKindOfClass:[NSArray class]])) {
            callback(op , responseObject, nil);
        }else {
            NSData *data = (NSData *)responseObject;
            NSError *error;
            id weatherDic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (([weatherDic isKindOfClass:[NSDictionary class]]) || ([weatherDic isKindOfClass:[NSArray class]])) {
                callback(op, weatherDic, nil);
            }else {
                NSString *str = [[NSString alloc] initWithData:data encoding:kCFStringEncodingUTF8];

                NSString *jsonStr = [NSString decodeBase64Data:data];
                
                id result = [jsonStr toArrayOrNSDictionary];
                callback(op, result, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (error) {
            [APIBasis changeCurrentBaseURLIndex];
        }
        if (startIndex < 4) {
            [self postPath:path parameters:parameters andStartIndex:(startIndex + 1) completion:^(AFHTTPRequestOperation *operation, id JSONObject, NSError *error) {
                callback(operation, JSONObject, nil);
            }];
        }else {
            callback(op, nil, error);
        }
    }];
}

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters attachFiles:(void (^)(id <AFMultipartFormData> formData))bodyConstructBlock uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback
{
    [self postPath:path parameters:parameters attachFiles:bodyConstructBlock uploadProgressBlock:progressBlock andStartIndex:1 completion:callback];
}

- (void)postPath:(NSString *)path parameters:(NSDictionary *)parameters attachFiles:(void (^)(id <AFMultipartFormData> formData))bodyConstructBlock uploadProgressBlock:(void (^)(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progressBlock andStartIndex:(NSInteger)startIndex completion:(void (^)(AFHTTPRequestOperation *operation, id JSONObject, NSError *error))callback
{
    AFHTTPRequestOperation *op;

    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    op = [self.manager POST:path parameters:parameters constructingBodyWithBlock:bodyConstructBlock success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        if (([responseObject class] == [NSDictionary class]) || ([responseObject class] == [NSArray class])) {
            callback((AFHTTPRequestOperation *)operation , responseObject, nil);
        }else {
            NSData *data = (NSData *)responseObject;
            NSError *error;
            id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
            if (([result isKindOfClass:[NSDictionary class]]) || ([result isKindOfClass:[NSArray class]])) {
                callback((AFHTTPRequestOperation *)operation, result, nil);
            }else {
                NSString *jsonStr = [NSString decodeBase64Data:data];
                
                result = [jsonStr toArrayOrNSDictionary];
                callback((AFHTTPRequestOperation *)operation, result, nil);
            }
        }
    } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
        if (startIndex < 4) {
            [self postPath:path parameters:parameters attachFiles:bodyConstructBlock uploadProgressBlock:progressBlock andStartIndex:(startIndex+1) completion:^(AFHTTPRequestOperation *operation, id JSONObject, NSError *error) {
                callback(operation, JSONObject, error);
            }];
        }else {
            callback((AFHTTPRequestOperation *)operation, nil, error);
        }
    }];
}

- (void)cancelAllHTTPOperationsWithMethod:(NSString *)method
                                     path:(NSString *)path
{
    NSURL *url = [NSURL URLWithString:path relativeToURL:self.manager.baseURL];
    NSString *pathToBeMatched = [url path];
    
    for (NSOperation *operation in [self.manager.operationQueue operations]) {
        if (![operation isKindOfClass:[AFHTTPRequestOperation class]]) {
            continue;
        }
        
        BOOL hasMatchingMethod = !method || [method isEqualToString:[[(AFHTTPRequestOperation *)operation request] HTTPMethod]];
        BOOL hasMatchingPath = [[[[(AFHTTPRequestOperation *)operation request] URL] path] isEqual:pathToBeMatched];
        
        if (hasMatchingMethod && hasMatchingPath) {
            [operation cancel];
        }
    }
}

+ (NSString *)currentBaseURL
{
    return kBaseURL;
}

+ (void)changeCurrentBaseURLIndex
{
    NSInteger baseURLIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"baseURLIndex"] integerValue];
    
    baseURLIndex += 1;
    if (baseURLIndex == 4) {
        baseURLIndex = 0;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:baseURLIndex] forKey:@"baseURLIndex"];
}

@end
