//
//  BeanGamePhase.m
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGamePhase.h"
#import "BeanGamePhase+SubClass.h"
#import "BeanGamePhase+Private.h"

@implementation BeanGamePhase

- (void)setState:(BeanGamePhaseState)state
{
    if (_state != state) {
        _state = state;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:BeanGamePhaseDidUpdateStateNotification object:self];
    }
}

- (void)start
{
    if (_state == BeanGamePhaseStateInitialized) {
        self.state = BeanGamePhaseStateRunning;
        [self _runPhase];
    }
}

- (void)_gameWillStart
{
    
}

- (void)_runPhase
{
    // implement in subclass
}

- (void)_gameDidFinish
{
    
}

@end

NSString * const BeanGamePhaseDidUpdateStateNotification = @"BeanGamePhaseDidUpdateStateNotification";
