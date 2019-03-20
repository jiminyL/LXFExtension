//
//  UIImage+SSToolKitAdditions.h
//  KdsSoftHD
//
//  Created by PChome on 14-4-15.
//  Copyright (c) 2014年 PCHome. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface UIImage (LXFToolkit)

+ (UIImage *)blurryImage:(UIImage *)image withBlurLevel:(CGFloat)blur;

-(UIImage *)clipImageWithSize:(CGSize)size;

-(UIImage*)getSubImage:(CGRect)rect;

- (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize;

- (UIImage *)rotation:(UIImageOrientation)orientation;

+ (UIImage*)createIconWithImage:(UIImage*)src imageOrientation:(NSDictionary*)info;

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;

+ (UIImage *)thumbnailImageFromALAsset:(ALAsset *)asset;

+ (NSData *)imageDataWithALAssert:(ALAsset *)result;

//方向矫正
+ (UIImage *)fixOrientation:(UIImage *)srcImg;

//等比压缩
+(UIImage *)imageCompressForSize:(UIImage *)sourceImage targetSize:(CGSize)size;

+ (UIImage *)createImageWithColor:(UIColor *)color frame:(CGRect)rect;

@end
