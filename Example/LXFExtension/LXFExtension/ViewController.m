//
//  ViewController.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/3/20.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "ViewController.h"
#import "UIView+LXFCommon.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic) BOOL flag;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(50.f, 100.f, 50.f, 50.f)];
    [_label setText:@"fafda"];
    [_label setTextColor:UIColor.blackColor];
    [self.view addSubview:_label];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (_flag) {
        [self.label rotaion180];
    }else {
        [self.label rotationToOrg];
    }
    self.flag = !self.flag;
}

@end
