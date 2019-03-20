//
//  APICooperationInfo.m
//  KDSLife
//
//  Created by PChome on 14-9-16.
//
//

#import "APICooperationInfo.h"
#import "APIBasis.h"

#import "LXF_config.h"

@implementation APICooperationInfo

+ (APICooperationInfo *)sharedInstance {
	static APICooperationInfo* sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
        
    });
	return sharedInstance;
}

- (void)cancelWithPath:(NSString *)path
{
    [self.apiBase cancelAllHTTPOperationsWithMethod:@"GET" path:path];
}

//下载图片
- (void)fetchPhotoWithPath:(NSString *)path
                   process:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))process
               andCallback:(void (^)(BOOL success, id message, id responseObject))callback
{
    if ([self.downloadingPool containsObject:strOrEmpty(path)]) {
        callback(NO, @"正在下载", nil);
        return;
    }
    [self.downloadingPool addObject:strOrEmpty(path)];
    [self.apiBase getPhotoPath:strOrEmpty(path) process:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        process(bytesRead, totalBytesRead, totalBytesExpectedToRead);
    } completion:^(AFHTTPRequestOperation *operation, id JSONObject, NSError *error) {
        if ([self.downloadingPool containsObject:strOrEmpty(path)]) {
            [self.downloadingPool removeObject:strOrEmpty(path)];
        }
        if (JSONObject) {
            callback(YES, @"", JSONObject);
        }else {
            callback(NO, @"", JSONObject);
        }
    }];
}


- (NSMutableArray *)downloadingPool
{
    if (!_downloadingPool) {
        _downloadingPool = [[NSMutableArray alloc] init];
    }
    return _downloadingPool;
}

@end
