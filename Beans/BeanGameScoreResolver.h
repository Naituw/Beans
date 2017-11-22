//
//  BeansGameScoreResolver.h
//  Beans
//
//  Created by 吴天 on 22/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanView.h"

@interface BeanGameScoreResolver : NSObject

- (instancetype)initWithContentView:(UIView *)contentView;

- (void)appendScore:(NSInteger)score;

@property (nonatomic, assign, readonly) NSInteger score;
@property (nonatomic, assign, readonly) NSInteger combo;

@end
