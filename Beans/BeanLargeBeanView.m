//
//  BeanLargeBeanView.m
//  Beans
//
//  Created by wutian on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanLargeBeanView.h"
#import "BeanView+SubClass.h"

@implementation BeanLargeBeanView

+ (NSString *)imageName
{
    return @"orange_normal";
}

+ (NSString *)bittenImageName
{
    return @"orange_eat";
}

+ (CGSize)defaultSize
{
    return CGSizeMake(60, 60);
}

- (NSInteger)score
{
    return 200;
}

@end
