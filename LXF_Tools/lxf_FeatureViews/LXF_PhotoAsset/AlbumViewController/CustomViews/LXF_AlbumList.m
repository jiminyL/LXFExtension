//
//  LXF_AlbumList.m
//  LXFExtension
//
//  Created by 梁啸峰 on 2019/5/8.
//  Copyright © 2019 GuanNiu. All rights reserved.
//

#import "LXF_AlbumList.h"
#import "LXF_AlbumTableViewCell.h"

#import "LXF_AlbumModel.h"

#import "LXF_PhotoExtension.h"

@interface LXF_AlbumList()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) LXF_PhotoExtension *extension;

@property (nonatomic, strong) LXF_TableView *tableView;
@property (nonatomic, copy) NSArray<LXF_AlbumModel *> *dataArr;

@end


@implementation LXF_AlbumList

- (instancetype)init {
    if (self = [super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        [self fetchAlbum];
    }
    return self;
}

- (void)layoutSubviews {
    [self refreshViews];
}

- (void)setDataArr:(NSArray<LXF_AlbumModel *> *)dataArr {
    _dataArr = dataArr;
    
    [self refreshViews];
}

- (void)refreshViews {
    [self.tableView setFrame:self.bounds];
    [self.tableView reloadData];
}

#pragma mark - Data
- (void)fetchAlbum {
    [self makeToastActivity];
    __weak typeof(self) mself = self;
    [self.extension fetchCameraRollAlbumWithCallback:^(NSArray<LXF_AlbumModel *> *models) {
        [mself hideToastActivity];
        mself.dataArr = models;
    }];
}

#pragma mark - TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [LXF_AlbumTableViewCell height];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"LXF_AlbumTableViewCellIdentifier";
    
    LXF_AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[LXF_AlbumTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    LXF_AlbumModel *albumModel = self.dataArr[indexPath.row];
    [cell setAlbum:albumModel];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    LXF_AlbumModel *albumModel = self.dataArr[indexPath.row];
    if (self.didTouchAlbum) {
        self.didTouchAlbum(albumModel);
    }
}

#pragma mark - Lazy
- (LXF_TableView *)tableView {
    if (!_tableView) {
        _tableView = [[LXF_TableView alloc] init];
        [_tableView setDataSource:self];
        [_tableView setDelegate:self];
        [self addSubview:_tableView];
    }
    return _tableView;
}

- (LXF_PhotoExtension *)extension {
    if (!_extension) {
        _extension = [[LXF_PhotoExtension alloc] init];
    }
    return _extension;
}

@end
