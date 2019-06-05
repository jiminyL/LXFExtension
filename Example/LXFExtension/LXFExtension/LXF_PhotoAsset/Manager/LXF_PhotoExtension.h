//
//  PhotoManager.h
//  KDSLife
//
//  Created by PChome on 16/3/17.
//
//

#import <Foundation/Foundation.h>

#import "LXF_config.h"

#import "LXF_AlbumModel.h"
#import <Photos/Photos.h>

@interface LXF_PhotoExtension : NSObject

+ (LXF_PhotoExtension *)sharedInstance;

///是否可以访问相册
- (void)canVisteAlbum:(void (^)(BOOL success))callback;

///获取相册信息
- (void)fetchCameraRollAlbumWithCallback:(void (^)(NSArray<LXF_AlbumModel *> *models))callback;

/// Get Assets 获得照片数组
- (void)fetchAssetsFromAlbumModel:(LXF_AlbumModel *)albumModel completion:(void (^)(NSArray<PHAsset *> *))completion;

///获取单张图片大小
- (void)fetchPhototBytesWithAsset:(id)asset completion:(void (^)(NSString *totalBytes))completion;

- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size;

- (void)getOriginalPhotoWithAsset:(id)asset completion:(void (^)(NSData *photo,NSDictionary *info))completion;

///获取视频路径
- (void)fetchVideoWithAsset:(PHAsset *)asset completion:(void (^)(NSURL *fileUrl, NSDictionary *info))completion;

- (NSDictionary *)fetchAllSuffixWithPHFetchResult:(PHFetchResult *)fetchResult;
- (NSDictionary *)fetchAllSuffixWithALAssetArr:(NSArray *)arr;

///判断图片是否为会动的gif
- (BOOL)isActivityGifWithImageData:(NSData *)imageData;

- (BOOL)isContainAsset:(NSObject *)asset inArr:(NSArray *)arr;
- (NSInteger)fetchIndexWithAsset:(NSObject *)asset inArr:(NSArray *)arr;

@property (nonatomic, strong) PHCachingImageManager *imageManager;
@property (nonatomic, strong) PHImageRequestOptions *imageRequestOptions;
@property (nonatomic, strong) PHImageRequestOptions *imageThumRequestOptions;

@end
