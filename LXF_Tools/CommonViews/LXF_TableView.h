//
//  LXFTableView.h
//  iBuilding
//
//  Created by 梁啸峰 on 2019/2/28.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface LXF_TableView : UITableView

- (void)addRefreshBlock:(void(^)(void))refreshBlock;
- (void)addRefreshTarget:(id)target action:(SEL)action;
- (void)addLoadMoreBlock:(void(^)(void))loadMoreBlock;
- (void)addLoadMoreTarget:(id)target action:(SEL)action;

@end

NS_ASSUME_NONNULL_END
