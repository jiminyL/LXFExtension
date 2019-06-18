//
//  PointsSwitchBar.h
//  iBuilding
//
//  Created by 梁啸峰 on 2017/8/9.
//
//

#import <UIKit/UIKit.h>

typedef enum
{
    LXFSwitchBarStyleTypeBottomLine     =   0,
    LXFSwitchBarStyleTypeBackground     =   1,
    LXFSwitchBarStyleTypeNike           =   2
}LXFSwitchBarStyleType;

@interface LXFSwitchBar : UIView

@property (nonatomic, copy) void (^didTouchButton)(NSInteger index);

@property (nonatomic) NSInteger currentIndex;

- (instancetype)initBottomLineStyleWithNameArray:(NSArray<NSString *> *)nameArray andTextColor:(UIColor *)textColor andTextSeleteColor:(UIColor *)textSeleteColor andLineColor:(UIColor *)lineColor andFont:(UIFont *)font;
- (instancetype)initBottomLineStyleWithNameArray:(NSArray<NSString *> *)nameArray andTextColor:(UIColor *)textColor andLineColor:(UIColor *)lineColor;
- (instancetype)initBackgroundStyleWithNameArray:(NSArray<NSString *> *)nameArray andTextColor:(UIColor *)textColor andBgColor:(UIColor *)bgColor;
- (instancetype)initNikeStyleWithNameArray:(NSArray<NSString *> *)nameArray andUnseletedImage:(UIImage *)unSeletedImage andSeletedImage:(UIImage *)seleteImage andTextColor:(UIColor *)textColor andImageAtRight:(BOOL)imageAtRight andScrollType:(BOOL)scrollType;

- (void)resetNameArr:(NSArray<NSString *> *)nameArr;

@end
