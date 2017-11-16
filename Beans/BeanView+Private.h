//
//  BeanView+Private.h
//  Beans
//
//  Created by 吴天 on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanView.h"

@interface BeanView ()

@property (nonatomic, assign) CFTimeInterval timestamp;
@property (nonatomic, assign) double velocity;
@property (nonatomic, assign) double biteMouthPosition; // 0.0 ~ 1.0: left to right

- (void)startRotationAnimation;

@end
