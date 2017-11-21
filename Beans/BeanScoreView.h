//
//  BeanScoreView.h
//  Beans
//
//  Created by wutian on 2017/11/21.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeanScoreView : UIView

@property (nonatomic, assign) NSInteger score;

@property (nonatomic, copy) void(^sizeUpdateBlock)(void);

@end
