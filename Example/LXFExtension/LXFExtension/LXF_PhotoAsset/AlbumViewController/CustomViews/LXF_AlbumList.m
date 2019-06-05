//
//  LXF_AlbumList.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/8.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_AlbumList.h"
#import "LXF_config.h"

@interface LXF_AlbumList()

@property (nonatomic, strong) LXF_TableView *tableView;

@end


@implementation LXF_AlbumList

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self refreshViews];
}

- (void)refreshViews
{
    
}

@end
