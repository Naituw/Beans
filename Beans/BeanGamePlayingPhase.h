//
//  BeanGamePlayingPhase.h
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGamePhase.h"

@interface BeanGamePlayingPhase : BeanGamePhase

- (void)setLeftMouthPoint:(CGPoint)leftPoint rightMouthPoint:(CGPoint)rightPoint;
- (void)bite;
- (void)unbite;

@property (nonatomic, assign, readonly) NSInteger score;

@end
