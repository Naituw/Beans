//
//  BeanLayerContainerView.m
//  Beans
//
//  Created by 吴天 on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanLayerContainerView.h"

@implementation BeanLayerContainerView

- (instancetype)initWithBeanView:(BeanView *)beanView
{
    if (self = [super initWithFrame:beanView.frame]) {
        [beanView removeFromSuperlayer];
        [self.layer addSublayer:beanView];
        beanView.frame = self.bounds;
        _beanView = beanView;
    }
    return self;
}

@end
