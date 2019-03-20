//
//  LXFCommon.m
//  KDSLife
//
//  Created by PChome on 14-10-22.
//
//

#import <sys/utsname.h>
#import <mach/mach.h>
#import "LXF_Common.h"
#import "LXF_Reachability.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation LXF_Common

+ (LXF_Common *)sharedInstance {
    static LXF_Common* sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

//去除空值
+ (id)dataRemoveNull:(id)dataOrg {
    id resultData = nil;
    if ([dataOrg isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictTemp = [[NSMutableDictionary alloc] initWithDictionary:dataOrg];
        for (int i = 0; i < [dictTemp allKeys].count; i++) {
            NSString *key = [[dictTemp allKeys] objectAtIndex:i];
            id value = dictTemp[key];
            if ([value isKindOfClass:[NSNull class]]) {
                [dictTemp setObject:@"" forKey:key];
            }
            if ([value isKindOfClass:[NSDictionary class]] || [value isKindOfClass:[NSArray class]]) {
                [dictTemp setObject:[self dataRemoveNull:value] forKey:key];
            }
        }
        resultData = dictTemp;
    }
    
    if ([dataOrg isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrayTemp = [[NSMutableArray alloc] initWithArray:dataOrg];
        for (int i = 0; i < arrayTemp.count; i++) {
            id value = arrayTemp[i];
            if ([value isKindOfClass:[NSNull class]]) {
                [arrayTemp replaceObjectAtIndex:i withObject:@""];
            }
            if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                [arrayTemp replaceObjectAtIndex:i withObject:[self dataRemoveNull:value]];
            }
        }
        resultData = arrayTemp;
    }
    
    if ([dataOrg isKindOfClass:[NSNull class]]) {
        resultData = dataOrg = @"";
    }
    
    return resultData;
}

+ (BOOL)canVisitPhotos
{
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.f) {
        ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
        if (author == ALAuthorizationStatusRestricted || author == ALAuthorizationStatusDenied) {
            return NO;
        }
    }
    
    return YES;
}

+ (BOOL)isWifiConnect
{
    return ([[LXF_Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi);
}

//---------------------------------

+ (NSRange)searchRangeEndWithStRangeStart:(NSRange)rangeStart
                             andSearchStr:(NSString *)searchStr
                                andOrgStr:(NSString *)orgStr
                                 andCount:(NSInteger)count
{
    NSRange rangeEnd = [orgStr rangeOfString:searchStr];
    if (rangeEnd.location == NSNotFound) {
        return rangeEnd;
    }
    if (rangeEnd.location > rangeStart.location - count) {
        rangeEnd.location += count;
        return rangeEnd;
    }
    NSString *temp = nil;
    if (rangeEnd.location <= rangeStart.location) {
        temp = [orgStr substringFromIndex:rangeEnd.location + rangeEnd.length];
        //        rangeEnd = [temp rangeOfString:searchStr];
    }
    NSInteger tempCount = rangeEnd.location + rangeEnd.length + count;
    return [self searchRangeEndWithStRangeStart:rangeStart andSearchStr:searchStr andOrgStr:temp andCount:tempCount];
}

+ (NSRange)searchRangeEndWithStRangeStart:(NSRange)rangeStart
                              andStartStr:(NSString *)startStr
                             andSearchStr:(NSString *)searchStr
                                andOrgStr:(NSString *)orgStr
                                 andCount:(NSInteger)count
{
    NSInteger allCountStart = [self countOfStr:searchStr inOrgStr:orgStr andCount:0];
    NSInteger bettwenCount = [self countBetweenStartStr:startStr andEndStr:searchStr andOrgStr:orgStr andCount:0];
    
    NSArray *endStrComponents = [orgStr componentsSeparatedByString:searchStr];
    if (allCountStart == -1 || endStrComponents.count < allCountStart || bettwenCount == -1) {
        NSRange rangeEnd = [orgStr rangeOfString:searchStr];
        if (rangeEnd.location != NSNotFound) {
            return rangeEnd;
        }else {
            return NSMakeRange(NSNotFound, NSNotFound);
        }
    }
    if (bettwenCount >= allCountStart) {
        NSRange rangeStart = [orgStr rangeOfString:startStr];
        return rangeStart;
    }
    NSInteger location = 0;
    for (int i=0; i<endStrComponents.count; i++) {
        NSString *str = endStrComponents[i];
        if (i == bettwenCount) {
            location += str.length;
            break;
        }else {
            location += (str.length + 1);
            location += searchStr.length;
        }
    }
    return NSMakeRange(location, searchStr.length);
    
    
    /*
     NSRange rangeEnd = [orgStr rangeOfString:searchStr];
     if (rangeEnd.location == NSNotFound) {
     return rangeEnd;
     }
     if (rangeEnd.location > rangeStart.location - count) {
     rangeEnd.location += count;
     return rangeEnd;
     }
     NSString *temp = nil;
     if (rangeEnd.location <= rangeStart.location) {
     temp = [orgStr substringFromIndex:rangeEnd.location + rangeEnd.length];
     //        rangeEnd = [temp rangeOfString:searchStr];
     }
     NSInteger tempCount = rangeEnd.location + rangeEnd.length + count;
     return [self searchRangeEndWithStRangeStart:rangeStart andSearchStr:searchStr andOrgStr:temp andCount:tempCount];
     */
}

+ (NSInteger)countOfStr:(NSString *)str inOrgStr:(NSString *)orgStr andCount:(NSInteger)count
{
    if (!str || !orgStr) {
        return count;
    }
    if (str.length <= 0 || orgStr.length <= 0) {
        return count;
    }
    NSRange rangeStart = [orgStr rangeOfString:str];
    if (rangeStart.location == NSNotFound) {
        return count;
    }
    NSString *tempStr = [orgStr substringFromIndex:rangeStart.location + rangeStart.length];
    count ++;
    return [self countOfStr:str inOrgStr:tempStr andCount:count];
}

+ (NSInteger)countBetweenStartStr:(NSString *)startStr andEndStr:(NSString *)endStr andOrgStr:(NSString *)orgStr andCount:(NSInteger)count
{
    if (!startStr || !endStr || !orgStr) {
        return count;
    }
    if (startStr.length <= 0 || endStr.length <= 0 || orgStr.length <= 0) {
        return count;
    }
    NSRange rangeStart = [orgStr rangeOfString:startStr];
    NSRange rangeEnd = [orgStr rangeOfString:endStr];
    
    if (rangeStart.location == NSNotFound || rangeEnd.location == NSNotFound) {
        return count - 1;
    }
    if (rangeStart.location > rangeEnd.location) {
        return count - 1;
    }
    NSString *tempStr = nil;
    if (count > 0) {
        if (rangeStart.location < rangeEnd.location) {
            tempStr = [orgStr substringFromIndex:rangeEnd.location + rangeEnd.length];
        }else {
            tempStr = [orgStr substringFromIndex:rangeStart.location + rangeStart.length];
        }
    }else {
        tempStr = [orgStr substringFromIndex:rangeStart.location + rangeStart.length];
    }
    count ++;
    return [self countBetweenStartStr:startStr andEndStr:endStr andOrgStr:tempStr andCount:count];
}

- (NSString *)getDeviceVersionInfo
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    return deviceString;
}

- (NSString *)getDeviceCustomName
{
    return  [UIDevice currentDevice].name;
}

- (NSString *)correspondVersion
{
    NSString *correspondVersion = [self getDeviceVersionInfo];
    
    if ([correspondVersion isEqualToString:@"i386"])        return@"Simulator";
    if ([correspondVersion isEqualToString:@"x86_64"])       return @"Simulator";
    
    if ([correspondVersion isEqualToString:@"iPhone1,1"])   return@"iPhone 1";
    if ([correspondVersion isEqualToString:@"iPhone1,2"])   return@"iPhone 3";
    if ([correspondVersion isEqualToString:@"iPhone2,1"])   return@"iPhone 3S";
    if ([correspondVersion isEqualToString:@"iPhone3,1"] || [correspondVersion isEqualToString:@"iPhone3,2"])   return@"iPhone 4";
    if ([correspondVersion isEqualToString:@"iPhone4,1"])   return@"iPhone 4S";
    if ([correspondVersion isEqualToString:@"iPhone5,1"] || [correspondVersion isEqualToString:@"iPhone5,2"])   return @"iPhone 5";
    if ([correspondVersion isEqualToString:@"iPhone5,3"] || [correspondVersion isEqualToString:@"iPhone5,4"])   return @"iPhone 5C";
    if ([correspondVersion isEqualToString:@"iPhone6,1"] || [correspondVersion isEqualToString:@"iPhone6,2"])   return @"iPhone 5S";
    if ([correspondVersion isEqualToString:@"iPhone7,1"])   return@"iPhone 6P";
    if ([correspondVersion isEqualToString:@"iPhone7,2"])   return@"iPhone 6";
    if ([correspondVersion isEqualToString:@"iPhone8,1"])   return@"iPhone 6s";
    if ([correspondVersion isEqualToString:@"iPhone8,2"])   return@"iPhone 6sP";
    if ([correspondVersion isEqualToString:@"iPhone8,4"])   return@"iPhone SE";

    if ([correspondVersion isEqualToString:@"iPod1,1"])     return@"iPod Touch 1";
    if ([correspondVersion isEqualToString:@"iPod2,1"])     return@"iPod Touch 2";
    if ([correspondVersion isEqualToString:@"iPod3,1"])     return@"iPod Touch 3";
    if ([correspondVersion isEqualToString:@"iPod4,1"])     return@"iPod Touch 4";
    if ([correspondVersion isEqualToString:@"iPod5,1"])     return@"iPod Touch 5";
    
    if ([correspondVersion isEqualToString:@"iPad1,1"])     return@"iPad 1";
    if ([correspondVersion isEqualToString:@"iPad2,1"] || [correspondVersion isEqualToString:@"iPad2,2"] || [correspondVersion isEqualToString:@"iPad2,3"] || [correspondVersion isEqualToString:@"iPad2,4"])     return@"iPad 2";
    if ([correspondVersion isEqualToString:@"iPad2,5"] || [correspondVersion isEqualToString:@"iPad2,6"] || [correspondVersion isEqualToString:@"iPad2,7"] )      return @"iPad Mini";
    if ([correspondVersion isEqualToString:@"iPad3,1"] || [correspondVersion isEqualToString:@"iPad3,2"] || [correspondVersion isEqualToString:@"iPad3,3"] || [correspondVersion isEqualToString:@"iPad3,4"] || [correspondVersion isEqualToString:@"iPad3,5"] || [correspondVersion isEqualToString:@"iPad3,6"])      return @"iPad 3";
    
    if ([correspondVersion rangeOfString:@"iPhone"].length != NSNotFound) {
        return correspondVersion;
    }
    
    return correspondVersion;
}

// 获取当前设备可用内存(单位：MB）
- (double)availableMemory
{
    vm_statistics_data_t vmStats;
    mach_msg_type_number_t infoCount = HOST_VM_INFO_COUNT;
    kern_return_t kernReturn = host_statistics(mach_host_self(),
                                               HOST_VM_INFO,
                                               (host_info_t)&vmStats,
                                               &infoCount);
    
    if (kernReturn != KERN_SUCCESS) {
        return NSNotFound;
    }
    
    return ((vm_page_size *vmStats.free_count) / 1024.0) / 1024.0;
}

//设备总内存
- (double)getTotalMemorySize
{
    return ([NSProcessInfo processInfo].physicalMemory / 1024.f / 1024.f);
}

+ (CGFloat)roundOffOnePoint:(CGFloat)floatValue
{
    return round(floatValue * 10) / 10;
}

+ (CGFloat)roundOffTwoPoint:(CGFloat)floatValue
{
    return round(floatValue * 100) / 100;
}

+ (CGFloat)roundOffThreePoint:(CGFloat)floatValue
{
    return round(floatValue * 1000) / 1000;
}

+ (double)exactOneFloat:(double)floatValue
{
    int decimalNum = 1; //保留的小数位数
    double doubleNumber = floatValue;
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [nFormat setMaximumFractionDigits:decimalNum];
    
    return doubleNumber;
}

+ (double)exactTwoFloat:(double)floatValue
{
    int decimalNum = 2; //保留的小数位数
    double doubleNumber = floatValue;
    NSNumberFormatter *nFormat = [[NSNumberFormatter alloc] init];
    [nFormat setNumberStyle:NSNumberFormatterDecimalStyle];
    [nFormat setMaximumFractionDigits:decimalNum];
        
    return doubleNumber;
}

+ (int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}



@end
