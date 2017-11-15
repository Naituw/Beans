//
//  BeanGamePhase.h
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, BeanGamePhaseState) {
    BeanGamePhaseStateInitialized = 0,
    BeanGamePhaseStateRunning,
    BeanGamePhaseStateCompleted,
};

@interface BeanGamePhase : NSObject

+ (instancetype)phase;

@property (nonatomic, assign, readonly) BeanGamePhaseState state;
@property (nonatomic, copy, readonly) NSString * name;

@property (nonatomic, weak, readonly) UIView * contentView; // auto set by phase controller

- (void)start;

@end

extern NSString * const BeanGamePhaseDidUpdateStateNotification;
