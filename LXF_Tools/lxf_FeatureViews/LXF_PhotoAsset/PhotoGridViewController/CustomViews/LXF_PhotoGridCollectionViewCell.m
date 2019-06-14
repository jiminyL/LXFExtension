//
//  LXF_PhotoGridCollectionViewCell.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_PhotoGridCollectionViewCell.h"
#import "LXF_PhotoSeleteView.h"

@interface LXF_PhotoGridCollectionViewCell()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) LXF_PhotoSeleteView *selectView;

@end

@implementation LXF_PhotoGridCollectionViewCell

- (void)setAsset:(PHAsset *)asset {
    _asset = asset;
    
    [self refreshViews];
}

- (void)setDidSelected:(BOOL)didSelected
{
    _didSelected = didSelected;
    
    [self refreshViews];
}

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)refreshViews {
    [self.imageView setFrame:self.bounds];
    CGFloat width = MIN(kScreenWidth, kScreenHeight)/4;
    CGSize tSize = CGSizeMake(width*[UIScreen mainScreen].scale,width*[UIScreen mainScreen].scale);
    [[LXF_PhotoExtension sharedInstance].imageManager requestImageForAsset:self.asset targetSize:tSize contentMode:PHImageContentModeAspectFill options:[LXF_PhotoExtension sharedInstance].imageThumRequestOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        [self.imageView setImage:result];
    }];
    
    [self.selectView setFrame:CGRectMake(self.width/2, 0.f, self.width/2, self.height/2)];
    [self.selectView setDidSelected:self.didSelected];
}

#pragma mark - ButtonEvent
- (void)imageViewTouchEvent {
    if (self.didTouchImageView) {
        self.didTouchImageView(self.asset);
    }
}

- (void)selectViewTouchEvent:(UITapGestureRecognizer *)sender {
    LXF_PhotoSeleteView *selectView = (LXF_PhotoSeleteView *)sender.view;
    self.didSelected = !self.didSelected;
    
    [selectView setDidSelected:self.didSelected];
    if (self.didChangeSeleted) {
        self.didChangeSeleted(self.asset);
    }
}

#pragma mark - Lazy
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        [_imageView setClipsToBounds:YES];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTouchEvent)];
        [_imageView setUserInteractionEnabled:YES];
        [_imageView addGestureRecognizer:tapGes];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (LXF_PhotoSeleteView *)selectView {
    if (!_selectView) {
        _selectView = [[LXF_PhotoSeleteView alloc] init];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectViewTouchEvent:)];
        [_selectView setUserInteractionEnabled:YES];
        [_selectView addGestureRecognizer:tapGes];
        [self.contentView addSubview:_selectView];
    }
    return _selectView;
}

@end
