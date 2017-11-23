//
//  BeansGenerator.h
//  Beans
//
//  Created by wutian on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "BeanView.h"

typedef void (^BeansGeneratorUpdateBlock)(void);

@interface BeansGenerator : NSObject

- (instancetype)initWithContentView:(UIView *)contentView;

@property (nonatomic, assign, readonly) NSTimeInterval timeElapsed;
@property (nonatomic, copy) BeansGeneratorUpdateBlock updateBlock;

@property (nonatomic, strong, readonly) NSMutableArray<BeanView *> * currentBeanViews;

- (void)start;
- (void)stopGenerating;
- (void)stopUpdating;

@end
