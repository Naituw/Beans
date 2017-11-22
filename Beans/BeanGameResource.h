//
//  BeanGameResource.h
//  Beans
//
//  Created by wutian on 2017/11/21.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BeanGameResource : NSObject

+ (UIImage *)scoreImageWithNumber:(NSInteger)number;
+ (NSArray<UIImage *> *)scoreNumberImages;

+ (UIImage *)scoreBoardImageWithNumberCount:(NSUInteger)numberCount;

+ (NSArray<UIImage *> *)resultScoreNumberImages;

@end
