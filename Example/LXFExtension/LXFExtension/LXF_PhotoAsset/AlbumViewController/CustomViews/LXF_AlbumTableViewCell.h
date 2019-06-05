//
//  LXF_AlbumTableViewCell.h
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LXF_AlbumModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXF_AlbumTableViewCell : UITableViewCell

@property (nonatomic, weak) LXF_AlbumModel *album;

+ (CGFloat)height;

@end

NS_ASSUME_NONNULL_END
