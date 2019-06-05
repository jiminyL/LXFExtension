//
//  PhotoManager.m
//  KDSLife
//
//  Created by PChome on 16/3/17.
//
//

#import "LXF_PhotoExtension.h"

@interface LXF_PhotoExtension()


@end

@implementation LXF_PhotoExtension

+ (LXF_PhotoExtension *)sharedInstance {
    static LXF_PhotoExtension* sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] init];
        sharedInstance.imageRequestOptions = [[PHImageRequestOptions alloc] init];
        sharedInstance.imageRequestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
        sharedInstance.imageRequestOptions.networkAccessAllowed = YES;
        sharedInstance.imageRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        sharedInstance.imageRequestOptions.normalizedCropRect = CGRectMake(0.f, 0.f, kScreenWidth/2, kScreenWidth/2);
        sharedInstance.imageRequestOptions.synchronous = YES;
        
        sharedInstance.imageThumRequestOptions = [[PHImageRequestOptions alloc] init];
        sharedInstance.imageThumRequestOptions.resizeMode = PHImageRequestOptionsResizeModeNone;
        sharedInstance.imageThumRequestOptions.networkAccessAllowed = YES;
        sharedInstance.imageThumRequestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        CGFloat imgWidth = kScreenWidth/2 > 200.f ? 200.f : kScreenWidth/2;
        sharedInstance.imageThumRequestOptions.normalizedCropRect = CGRectMake(0.f, 0.f, imgWidth, imgWidth);
        sharedInstance.imageThumRequestOptions.synchronous = YES;
        
        sharedInstance.imageManager = [[PHCachingImageManager alloc] init];
    });
    return sharedInstance;
}

///是否可以访问相册
- (void)canVisteAlbum:(void (^)(BOOL success))callback
{
    if (@available(iOS 11.0, *)) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusNotDetermined || status == PHAuthorizationStatusAuthorized) {
                //yes
                callback(YES);
            }else {
                callback(NO);
            }
        }];
    }else {
        PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
        if (authStatus == PHAuthorizationStatusRestricted|| authStatus == PHAuthorizationStatusDenied) {
            //NO
            callback(NO);
        }else{
            callback(YES);
        }
    }
   
}

//获取相册信息
- (void)fetchCameraRollAlbumWithCallback:(void (^)(NSArray<LXF_AlbumModel *> *models))callback
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *groupArrays = [[NSMutableArray alloc] init];
        // 列出所有相册智能相册
        PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        for (int i=0; i<smartAlbums.count; i++) {
            PHAssetCollection *collection = smartAlbums[i];
            if (![collection isKindOfClass:[PHAssetCollection class]]) {
                continue;
            }
            PHFetchOptions *options = [[PHFetchOptions alloc] init];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %d OR mediaType = %d",PHAssetMediaTypeImage, PHAssetMediaTypeVideo];
            options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:options];
            if (assetsFetchResult.count > 0) {
                if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                    [groupArrays insertObject:[self modelWithResult:collection] atIndex:0];
                }else {
                    [groupArrays addObject:[self modelWithResult:collection]];
                }
            }
        }
        // 列出所有用户创建的相册
        PHFetchResult *topLevelUserCollections = [PHCollectionList fetchTopLevelUserCollectionsWithOptions:nil];
        for (int i=0; i<topLevelUserCollections.count; i++) {
            PHAssetCollection *collection = topLevelUserCollections[i];
            if (![collection isKindOfClass:[PHAssetCollection class]]) {
                continue;
            }
            PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
            if (assetsFetchResult.count > 0) {
                [groupArrays addObject:[self modelWithResult:collection]];
            }
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(groupArrays);
            }
        });
    });
}

- (LXF_AlbumModel *)modelWithResult:(id)result{
    LXF_AlbumModel *model = [[LXF_AlbumModel alloc] init];
    model.result = result;
    PHAssetCollection *collection = (PHAssetCollection *)result;
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    model.count = [fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeImage] + [fetchResult countOfAssetsWithMediaType:PHAssetMediaTypeVideo];
    model.name = strOrEmpty(collection.localizedTitle);
    return model;
}

//获得照片数组
- (void)fetchAssetsFromAlbumModel:(LXF_AlbumModel *)albumModel completion:(void (^)(NSArray<PHAsset *> *))completion
{
    id result = albumModel.result;
    NSMutableArray *photoArr = [NSMutableArray array];
    PHAssetCollection *collection = (PHAssetCollection *)result;
    PHFetchResult *fetchResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    [fetchResult enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        PHAsset *asset = (PHAsset *)obj;
        [photoArr addObject:asset];
    }];
    if (completion) completion(photoArr);
}

//获取单张图片大小
- (void)fetchPhototBytesWithAsset:(id)asset completion:(void (^)(NSString *totalBytes))completion
{
    [[PHImageManager defaultManager] requestImageDataForAsset:asset options:nil resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        NSString *bytes = [self getBytesFromDataLength:imageData.length];
        if (completion) {
            completion(bytes);
        }
    }];
}

//获取原图
- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(NSData *photo,NSDictionary *info))completion {
    if ([asset isKindOfClass:[PHAsset class]]) {
        [[PHImageManager defaultManager] requestImageDataForAsset:asset options:self.imageRequestOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
            if (downloadFinined && imageData) {
                if (completion) completion(imageData,info);
            }
        }];
        
    }else if ([asset isKindOfClass:[UIImage class]]) {
        NSData *data = UIImageJPEGRepresentation(asset, 1.f);
        if (completion) completion(data, nil);
    }else if ([asset isKindOfClass:[NSData class]]) {
        if (completion) completion(asset, nil);
    }
}

//获取视频路径
- (void)fetchVideoWithAsset:(PHAsset *)asset completion:(void (^)(NSURL *fileUrl, NSDictionary *info))completion
{
    PHVideoRequestOptions *options = [[PHVideoRequestOptions alloc] init];
    options.version = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    [manager requestAVAssetForVideo:asset options:options resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
        AVURLAsset *urlAsset = (AVURLAsset *)asset;
        
        NSURL *url = urlAsset.URL;
//        NSData *data = [NSData dataWithContentsOfURL:url];
        completion(url, info);
    }];
}

- (NSDictionary *)fetchAllSuffixWithPHFetchResult:(PHFetchResult *)fetchResult
{
    if (fetchResult) {
        NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
        for (int i=0; i<fetchResult.count; i++) {
            PHAsset *asset = fetchResult[i];
            if (@available(iOS 9.0, *) && asset) {
                NSString *orgFilename = strOrEmpty([asset valueForKey:@"filename"]);
                [resultDict setObject:strOrEmpty(orgFilename) forKey:asset.description];
            }
        }
        return resultDict;
    }else {        
        return nil;
    }
}

- (NSDictionary *)fetchAllSuffixWithALAssetArr:(NSArray *)arr
{
    if (arr) {
        NSMutableDictionary *resultDict = [[NSMutableDictionary alloc] init];
        for (int i=0; i<arr.count; i++) {
            ALAsset *asset = arr[i];
            if (asset) {
                ALAssetRepresentation *imageRep = [asset defaultRepresentation];
                [resultDict setObject:strOrEmpty(imageRep.filename) forKey:asset.description];
            }
        }
        return resultDict;
    }else {
        return nil;
    }
}


//判断图片是否为会动的gif
- (BOOL)isActivityGifWithImageData:(NSData *)imageData
{
    uint8_t c;
    
    [imageData getBytes:&c length:1];
    
    if (c == 0x47) {
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
        size_t imageCount = CGImageSourceGetCount(imageSource);
        if (imageCount > 1) {
            return YES;
        }else {
            return NO;
        }
    }else {
        return NO;
    }
}

- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (BOOL)isContainAsset:(NSObject *)asset inArr:(NSArray *)arr
{
    BOOL contain = NO;
    if (arr) {
        for (NSObject *tempAsset in arr) {
            if ([tempAsset.description isEqualToString:asset.description]) {
                contain = YES;
                break;
            }
        }
    }
    return contain;
}

- (NSInteger)fetchIndexWithAsset:(NSObject *)asset inArr:(NSArray *)arr
{
    NSInteger index = -1;
    for (int i=0; i<arr.count; i++) {
        NSObject *tempAsset = arr[i];
        if ([tempAsset.description isEqualToString:asset.description]) {
            index = i;
            break;
        }
    }
    return index;
}

@end
