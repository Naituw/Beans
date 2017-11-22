//
//  BeanPooPooView.m
//  Beans
//
//  Created by wutian on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanPooPooView.h"
#import "BeanView+SubClass.h"
#import "BeanGameDefines.h"

@implementation BeanPooPooView

+ (NSString *)imageName
{
    return @"shit_normal";
}

+ (NSString *)bittenImageName
{
    return @"shit_eat";
}

- (NSInteger)score
{
    return BeanGamePoopooScore;
}

+ (CGSize)defaultSize
{
    return CGSizeMake(BeanGameBeanPoopooSize, BeanGameBeanPoopooSize);
}

@end
