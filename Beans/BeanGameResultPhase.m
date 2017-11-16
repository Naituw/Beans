//
//  BeanGameResultPhase.m
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameResultPhase.h"
#import "BeanGamePhase+SubClass.h"

@implementation BeanGameResultPhase

- (void)_runPhase
{
    NSLog(@"Complete!");
    
    [self performSelector:@selector(finish) withObject:nil afterDelay:3];
}

- (void)finish
{
    self.state = BeanGamePhaseStateCompleted;
}

@end
