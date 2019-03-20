//
//  APICooperationInfo.h
//  KDSLife
//
//  Created by PChome on 14-9-16.
//
//

#import "APIInterface.h"

@interface APICooperationInfo : APIInterface

- (void)cancelWithPath:(NSString *)path;

@property (nonatomic, strong) NSMutableArray *downloadingPool;

/** 下载图片 */
- (void)fetchPhotoWithPath:(NSString *)path
                   process:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))process
               andCallback:(void (^)(BOOL success, id message, id responseObject))callback;

+ (APICooperationInfo *)sharedInstance;

@end
