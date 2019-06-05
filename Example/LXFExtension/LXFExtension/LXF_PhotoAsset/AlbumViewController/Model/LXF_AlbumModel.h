//
//  LXF_AlbumModel.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LXF_AlbumModel : NSObject

@property (nonatomic, strong) NSString *name;        ///< The album name
@property (nonatomic, assign) NSInteger count;       ///< Count of photos the album contain
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) id result;             ///< PHAssetCollection<PHAsset> or ALAssetsGroup<ALAsset>

///获取缩略图
- (void)fetchThumbImage:(void (^)(UIImage *image))callback;

@end

NS_ASSUME_NONNULL_END
