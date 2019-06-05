//
//  LXFTableView.m
//  iBuilding
//
//  Created by 梁啸峰 on 2019/2/28.
//

#import "LXF_TableView.h"

@implementation LXF_TableView

- (instancetype)init {
    if (self = [super initWithFrame:CGRectZero style:UITableViewStylePlain]) {
        [self setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.estimatedRowHeight = 0;
        self.estimatedSectionHeaderHeight = 0;
        self.estimatedSectionFooterHeight = 0;
    }
    return self;
}

- (void)addRefreshBlock:(void(^)(void))refreshBlock {
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refreshBlock();
    }];
}

- (void)addRefreshTarget:(id)target action:(SEL)action {
    self.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
}

- (void)addLoadMoreBlock:(void(^)(void))loadMoreBlock {
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        loadMoreBlock();
    }];
}

- (void)addLoadMoreTarget:(id)target action:(SEL)action {
    self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
}

@end
