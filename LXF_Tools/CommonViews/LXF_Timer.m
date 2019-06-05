//
//  LXFTimer.m
//  iBuilding
//
//  Created by 梁啸峰 on 2018/3/22.
//

#import "LXF_Timer.h"

@interface LXF_Timer()

@end

@implementation LXF_Timer

- (void)dispatchTimeWithPeriod:(double)period andCallback:(void (^)(dispatch_source_t timer))callback {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer =dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), (uint64_t)(period *NSEC_PER_SEC), 0);
    // 设置回调
    dispatch_source_set_event_handler(timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //编译时block会对timer对象强引用，使timer不会被过早释放
            if (callback) callback(timer);
        });
    });
    // 启动定时器
    dispatch_resume(timer);
}

@end
