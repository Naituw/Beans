//
//  BeanView.h
//  Beans
//
//  Created by wutian on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BeanViewState) {
    BeanViewStateNormal = 0,
    BeanViewStateBitten = 1,
};

@interface BeanView : UIView

+ (instancetype)view;

@property (nonatomic, assign, readonly) NSInteger score;
@property (nonatomic, assign, readonly) BeanViewState state;

- (void)bite;

@end
