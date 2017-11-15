//
//  BeanGamePhaseController.h
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BeanGamePhase.h"

@interface BeanGamePhaseController : NSObject

- (instancetype)initWithPhases:(NSArray<BeanGamePhase *> *)phases contentView:(UIView *)contentView;

- (void)start;

@end
