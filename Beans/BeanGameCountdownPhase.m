//
//  BeanGameCountdownPhase.m
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameCountdownPhase.h"
#import "BeanGamePhase+SubClass.h"

@interface BeanGameCountdownPhase ()

@property (nonatomic, assign) NSInteger remain;

@end

@implementation BeanGameCountdownPhase

- (void)_runPhase
{
    _remain = 3;
    [self tick];
}

- (void)tick
{
    if (_remain <= 0) {
        self.state = BeanGamePhaseStateCompleted;
        return;
    }
    [self _runAnimationWithRemainTime:_remain];
    _remain--;
    [self performSelector:@selector(tick) withObject:nil afterDelay:1.0];
}

- (void)_runAnimationWithRemainTime:(NSInteger)remain
{
    NSLog(@"count down: %zd", remain);
}

@end
