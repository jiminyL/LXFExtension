//
//  FileManager.m
//  iBuilding
//
//  Created by 梁啸峰 on 2017/8/7.
//
//

#import "LXF_FileManager.h"
#import "LXF_config.h"

@implementation LXF_FileManager

+ (BOOL)saveImageWithImageData:(NSData *)imageData andName:(NSString *)imageName
{
    if ([LXF_FileManager createDirInCache:@"ImageCache"]) {
        return [LXF_FileManager saveDataToCacheDir:[LXF_FileManager pathInCacheDirectory:@"ImageCache"]
                                          data:imageData
                                      dataName:[LXF_FileManager removeSpecialWithStr:strOrEmpty(imageName) andMd5:NO]];
    }
    return NO;
}

+ (NSData *)fetchImageDataWithImageName:(NSString *)imageName
{
    NSData *data = [LXF_FileManager loadDataWithPath:[LXF_FileManager pathInCacheDirectory:@"ImageCache"]
                                            name:[LXF_FileManager removeSpecialWithStr:strOrEmpty(imageName) andMd5:NO]];
    if (data) {
        return data;
    }
    return nil;
}

// 删除图片缓存
+ (BOOL)deleteDirInCache:(NSString *)dirName
{
    NSString *imageDir = [LXF_FileManager pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    bool isDeleted = false;
    if (isDir == YES && existed == YES){
        isDeleted = [fileManager removeItemAtPath:imageDir error:nil];
    }else {
        return YES;
    }
    
    return isDeleted;
}

//获取路径
+ (NSString *)pathInCacheDirectory:(NSString *)fileName
{
    NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [cachePaths objectAtIndex:0];
    return [cachePath stringByAppendingPathComponent:fileName];
}

+ (NSString *)pathInDocuments:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    return [path stringByAppendingPathComponent:fileName];
}

//创建缓存文件夹
+ (BOOL)createDirInCache:(NSString *)dirName
{
    NSString *imageDir = [self pathInCacheDirectory:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    BOOL isCreated = NO;
    if (!(isDir == YES && existed == YES)) {
        isCreated = [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}

+ (BOOL)createDirInDocuments:(NSString *)dirName
{
    NSString *imageDir = [self pathInDocuments:dirName];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:imageDir isDirectory:&isDir];
    BOOL isCreated = NO;
    if (!(isDir == YES && existed == YES)) {
        isCreated = [fileManager createDirectoryAtPath:imageDir withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if (existed) {
        isCreated = YES;
    }
    return isCreated;
}

//NSData本地缓存
+ (BOOL)saveDataToCacheDir:(NSString *)directoryPath data:(NSData *)data dataName:(NSString *)dataName
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    bool isSaved = NO;
    if (isDir == YES && existed == YES ) {
        NSError *error;
        isSaved = [data writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", dataName]] options:NSAtomicWrite error:&error];
    }
    return isSaved;
}

+ (NSData*)loadDataWithPath:(NSString *)directoryPath name:(NSString *)name
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( isDir == YES && dirExisted == YES ) {
        name = [NSString stringWithFormat:@"%@", name];
        
        NSString *imagePath = [directoryPath stringByAppendingPathComponent:name];
        BOOL fileExisted = [fileManager fileExistsAtPath:imagePath];
        if (!fileExisted) {
            return NULL;
        }
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        return data;
    }else {
        return NULL;
    }
}


+ (BOOL)saveArrayToCacheDir:(NSString *)directoryPath array:(NSArray *)array arrayName:(NSString *)arrayName
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    bool isSaved = NO;
    if (isDir == YES && existed == YES ) {
        isSaved = [array writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", arrayName]] atomically:YES];
    }
    return isSaved;
}

+ (NSArray *)loadArrWithPath:(NSString *)directoryPath name:(NSString *)name
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( isDir == YES && dirExisted == YES ) {
        name = [NSString stringWithFormat:@"%@.plist", name];
        
        NSString *path = [directoryPath stringByAppendingPathComponent:name];
        BOOL fileExisted = [fileManager fileExistsAtPath:path];
        if (!fileExisted) {
            return NULL;
        }
        NSArray *arr = [NSArray arrayWithContentsOfFile:path];
        return arr;
    }else {
        return NULL;
    }
}

+ (BOOL)saveDictToCacheDir:(NSString *)directoryPath dict:(NSDictionary *)dict arrayName:(NSString *)arrayName
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    bool isSaved = NO;
    if (isDir == YES && existed == YES ) {
        isSaved = [dict writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", arrayName]] atomically:YES];
    }
    return isSaved;
}

+ (NSDictionary *)loadDictWithPath:(NSString *)directoryPath name:(NSString *)name
{
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL dirExisted = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDir];
    if ( isDir == YES && dirExisted == YES ) {
        name = [NSString stringWithFormat:@"%@", name];
        
        NSString *path = [directoryPath stringByAppendingPathComponent:name];
        BOOL fileExisted = [fileManager fileExistsAtPath:path];
        if (!fileExisted) {
            return NULL;
        }
        NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
        return dict;
    }else {
        return NULL;
    }
}


+ (NSString *)removeSpecialWithStr:(NSString *)str andMd5:(BOOL)md5
{
    NSArray *arr = [NSArray arrayWithObjects:@"/", @":", nil];
    if (md5) {
        return [[self replaceOccurrencesOfString:str withString:@"" options:NSLiteralSearch replaceArray:arr] md5HexDigest];
    }
    return [self replaceOccurrencesOfString:str withString:@"" options:NSLiteralSearch replaceArray:arr];
}

+ (NSString *)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options replaceArray:(NSArray *)_replaceArray {
    NSMutableString *tempStr = [NSMutableString stringWithString:strOrEmpty(target)];
    NSArray *replaceArray = [NSArray arrayWithArray:_replaceArray];
    for(int i = 0; i < [replaceArray count]; i++){
        NSRange range = [target rangeOfString: [replaceArray objectAtIndex:i]];
        if(range.location != NSNotFound){
            [tempStr replaceOccurrencesOfString: [replaceArray objectAtIndex:i]
                                     withString: replacement
                                        options: options
                                          range: NSMakeRange(0, [tempStr length])];
        }
    }
    return tempStr;
}



@end
