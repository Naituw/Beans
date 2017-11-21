//
//  BeanGamePhase+SubClass.h
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGamePhase.h"

@interface BeanGamePhase ()

@property (nonatomic, assign) BeanGamePhaseState state;

- (void)_gameWillStart;
- (void)_runPhase;
- (void)_stopPhase;
- (void)_gameDidFinish;

@end
