//
//  BeanNoAnimationLayer.m
//  Beans
//
//  Created by wutian on 2017/11/21.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanNoAnimationLayer.h"

@implementation BeanNoAnimationLayer

- (id<CAAction>)actionForKey:(NSString *)event
{
    return [NSNull null];
}

@end
