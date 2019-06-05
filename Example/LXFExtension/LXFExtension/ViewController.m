//
//  ViewController.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/3/20.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "ViewController.h"
#import "LXF_PhotoAssetNavigationController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    LXF_PhotoAssetNavigationController *vc = [[LXF_PhotoAssetNavigationController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
