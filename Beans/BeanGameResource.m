//
//  BeanGameResource.m
//  Beans
//
//  Created by wutian on 2017/11/21.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameResource.h"

@implementation BeanGameResource

+ (NSArray<UIImage *> *)scoreNumberImages
{
    static NSArray * images = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray * a = [NSMutableArray arrayWithCapacity:10];
        for (NSInteger i = 0; i < 10; i++) {
            [a addObject:[UIImage imageNamed:[NSString stringWithFormat:@"COMBO_%zd", i]]];
        }
        images = a;
    });

    return images;
}

+ (UIImage *)scoreImageWithNumber:(NSInteger)number
{
    number = MAX(0, MIN(number, 9));
    
    return [self scoreNumberImages][number];
}

+ (UIImage *)scoreBoardImageWithNumberCount:(NSUInteger)numberCount
{
    static NSArray * images = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableArray * a = [NSMutableArray arrayWithCapacity:5];
        for (NSInteger i = 1; i < 6; i++) {
            [a addObject:[UIImage imageNamed:[NSString stringWithFormat:@"score_%zd", i]]];
        }
        images = a;
    });
    
    numberCount = MAX(1, MIN(numberCount, 5));
    
    return images[numberCount - 1];
}

@end
