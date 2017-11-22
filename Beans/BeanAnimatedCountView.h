//
//  BeanAnimatedCountView.h
//  Beans
//
//  Created by wutian on 2017/11/21.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanImageSequenceView.h"

@interface BeanAnimatedCountView : BeanImageSequenceView

- (instancetype)initWithNumberImages:(NSArray<UIImage *> *)numberImages;

@property (nonatomic, assign) NSUInteger count;
@property (nonatomic, assign, readonly) NSUInteger presentationCount;
@property (nonatomic, assign, readonly) NSUInteger digitCount;

- (void)setCount:(NSUInteger)count animateDuration:(NSTimeInterval)duration;

@end
