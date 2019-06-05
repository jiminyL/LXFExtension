//
//  LXF_AlbumList.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/8.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXF_AlbumModel;

NS_ASSUME_NONNULL_BEGIN

@interface LXF_AlbumList : UIView

@property (nonatomic, copy) void (^didTouchAlbum)(LXF_AlbumModel *album);

@end

NS_ASSUME_NONNULL_END
