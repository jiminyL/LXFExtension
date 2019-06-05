//
//  LXF_AlbumTableViewCell.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/9.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_AlbumTableViewCell.h"
#import "LXF_config.h"

@interface LXF_AlbumTableViewCell()

@property (nonatomic, strong) UIImageView *thumbIV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *cutLine;

@end

@implementation LXF_AlbumTableViewCell

- (void)setAlbum:(LXF_AlbumModel *)album {
    _album = album;
    
    [self refreshViews];
}

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)refreshViews {
    CGFloat offsetX = 0.f;
    if (self.album.thumbImage) {
        [self.thumbIV setImage:self.album.thumbImage];
    }else {
        __weak typeof(self) mself = self;
        [self.album fetchThumbImage:^(UIImage * _Nonnull image) {
            [mself.thumbIV setImage:image];
        }];
    }
    CGFloat height = [[self class] height];
    [self.thumbIV setFrame:CGRectMake(offsetX, 0.f, height, height)];
    offsetX += (height + 5.f);
    
    NSString *name = strOrEmpty(self.album.name);
    CGFloat nameWidth = [name widthForHeight:15.f font:[[self class] titleFont]];
    [self.titleLabel setText:strOrEmpty(self.album.name)];
    [self.titleLabel setFrame:CGRectMake(offsetX, 0.f, nameWidth, height)];
    offsetX += (nameWidth + 5.f);
    
    NSString *count = [NSString stringWithFormat:@"(%d)", (int)self.album.count];
    CGFloat countWidth = [count widthForHeight:15.f font:[[self class] descFont]];
    [self.countLabel setText:count];
    [self.countLabel setFrame:CGRectMake(offsetX, 0.f, countWidth, height)];
    offsetX += (countWidth + 5.f);
    
    [self.cutLine setFrame:CGRectMake(0.f, height - 0.5f, self.contentView.width, 0.5f)];
}

+ (CGFloat)height
{
    return 75.f;
}

#pragma mark - Lazy
- (UIImageView *)thumbIV
{
    if (!_thumbIV) {
        _thumbIV = [[UIImageView alloc] init];
        [_thumbIV setContentMode:UIViewContentModeScaleAspectFill];
        [_thumbIV setClipsToBounds:YES];
        [self.contentView addSubview:_thumbIV];
    }
    return _thumbIV;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[[self class] titleFont]];
        [_titleLabel setTextColor:[UIColor blackColor]];
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)countLabel
{
    if (!_countLabel) {
        _countLabel = [[UILabel alloc] init];
        [_countLabel setFont:[[self class] descFont]];
        [_countLabel setTextColor:[UIColor grayColor]];
        [self.contentView addSubview:_countLabel];
    }
    return _countLabel;
}

- (UIView *)cutLine
{
    if (!_cutLine) {
        _cutLine = [[UIImageView alloc] init];
        UIImage *image = [UIImage createImageWithColor:[UIColor lightGrayColor] frame:CGRectMake(0.f, 0.f, kScreenWidth, 0.5f)];
        [_cutLine setImage:image];
        [self.contentView addSubview:_cutLine];
    }
    return _cutLine;
}

+ (UIFont *)titleFont
{
    return [UIFont boldSystemFontOfSize:14.f];
}

+ (UIFont *)descFont
{
    return [UIFont systemFontOfSize:14.f];
}

@end
