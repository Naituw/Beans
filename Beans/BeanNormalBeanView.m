//
//  BeanNormalBeanView.m
//  Beans
//
//  Created by wutian on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanNormalBeanView.h"
#import "BeanView+SubClass.h"

@implementation BeanNormalBeanView

+ (NSString *)imageName
{
    return @"orange_normal";
}

+ (NSString *)bittenImageName
{
    return @"orange_eat";
}

- (NSInteger)score
{
    return 100;
}

@end
