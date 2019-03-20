//
//  LXFCommon.h
//  KDSLife
//
//  Created by PChome on 14-10-22.
//
//

#import "LXF_config.h"

@class PHImageRequestOptions;
@class PHCachingImageManager;

@interface LXF_Common : NSObject<UIAccelerometerDelegate>

@property (nonatomic) UIInterfaceOrientation deviceOrientation;

+ (LXF_Common *)sharedInstance;

//、NSDictionary,NSArray去除nil
+ (id)dataRemoveNull:(id)dataOrg;

+ (BOOL)isWifiConnect;

+ (BOOL)canVisitPhotos;

+ (NSRange)searchRangeEndWithStRangeStart:(NSRange)rangeStart
                             andSearchStr:(NSString *)searchStr
                                andOrgStr:(NSString *)orgStr
                                 andCount:(NSInteger)count;

+ (NSRange)searchRangeEndWithStRangeStart:(NSRange)rangeStart
                              andStartStr:(NSString *)startStr
                             andSearchStr:(NSString *)searchStr
                                andOrgStr:(NSString *)orgStr
                                 andCount:(NSInteger)count;

- (NSString *)getDeviceVersionInfo;
- (NSString *)getDeviceCustomName;
- (NSString *)correspondVersion;

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory;

//设备总内存
- (double)getTotalMemorySize;

+ (CGFloat)roundOffOnePoint:(CGFloat)floatValue;
+ (CGFloat)roundOffTwoPoint:(CGFloat)floatValue;
+ (CGFloat)roundOffThreePoint:(CGFloat)floatValue;
+ (double)exactOneFloat:(double)floatValue;
+ (double)exactTwoFloat:(double)floatValue;

+ (int)getRandomNumber:(int)from to:(int)to;

@end
