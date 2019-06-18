//
//  COFloatView.h
//  iBuilding
//
//  Created by 梁啸峰 on 2018/10/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum
{
    FloatViewContentLocationBottom          =       0,
    FloatViewContentLocationCenter          =       1,
}FloatViewContentLocation;

@interface LXF_FloatView : UIView

- (instancetype)initWithLocationStyle:(FloatViewContentLocation)location andCustomSize:(BOOL)customSize;

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic) FloatViewContentLocation location;
@property (nonatomic) BOOL customSize;

- (void)changeContentViewFrame;

- (void)show;
- (void)hidden;

@end

NS_ASSUME_NONNULL_END
