//
//  LXFTimer.h
//  iBuilding
//
//  Created by 梁啸峰 on 2018/3/22.
//

#import <Foundation/Foundation.h>

@interface LXF_Timer : NSObject

@property (nonatomic, copy) void (^didDoEvent)(void);

- (void)dispatchTimeWithPeriod:(double)period andCallback:(void (^)(dispatch_source_t timer))callback;

@end
