//
//  BeanGameController.h
//  Beans
//
//  Created by 吴天 on 2017/11/13.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>

@interface BeanGameController : NSObject

- (instancetype)initWithARSCNView:(ARSCNView *)scnView contentContainerView:(UIView *)contentView interfaceContainerView:(UIView *)interfaceView;

- (void)start;

@end
