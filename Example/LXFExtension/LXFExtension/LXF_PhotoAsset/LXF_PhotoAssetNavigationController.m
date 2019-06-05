//
//  LXF_PhotoAssetNavigationController.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PhotoAssetNavigationController.h"
#import "LXF_AlbumViewController.h"

@interface LXF_PhotoAssetNavigationController ()

@end

@implementation LXF_PhotoAssetNavigationController

- (instancetype)init
{
    LXF_AlbumViewController *albumVC = [[LXF_AlbumViewController alloc] init];
    if (self = [super initWithRootViewController:albumVC]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

@end
