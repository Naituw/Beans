//
//  BeanLargeBeanView.m
//  Beans
//
//  Created by wutian on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanLargeBeanView.h"
#import "BeanView+SubClass.h"
#import "BeanGameDefines.h"

@implementation BeanLargeBeanView

+ (NSString *)imageName
{
    return @"orange_normal_big";
}

+ (NSString *)bittenImageName
{
    return @"orange_eat_big";
}

+ (CGSize)defaultSize
{
    return CGSizeMake(BeanGameBeanLargeSize, BeanGameBeanLargeSize);
}

- (NSInteger)score
{
    return BeanGameLargeBeanScore;
}

@end
