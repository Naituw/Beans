//
//  BeanUIAdditions.m
//  Beans
//
//  Created by 吴天 on 23/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanUIAdditions.h"

UIEdgeInsets BeanScreenSafeAreaInsets()
{
    static UIEdgeInsets insets;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        insets = UIEdgeInsetsZero;
        if (@available(iOS 11.0, *)) {
            UIWindow * mainWindow = [[UIApplication sharedApplication] keyWindow];
            if (mainWindow) {
                insets = mainWindow.safeAreaInsets;
            }
        }
    });
    return insets;
}
