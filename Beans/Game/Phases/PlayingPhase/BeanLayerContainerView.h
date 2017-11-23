//
//  BeanLayerContainerView.h
//  Beans
//
//  Created by 吴天 on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeanView.h"

@interface BeanLayerContainerView : UIView

- (instancetype)initWithBeanView:(BeanView *)beanView;

@property (nonatomic, weak, readonly) BeanView * beanView;

@end
