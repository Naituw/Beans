//
//  BeanImageSequenceView.h
//  Beans
//
//  Created by 吴天 on 22/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeanImageSequenceView : UIView

@property (nonatomic, strong) NSString * content;
@property (nonatomic, assign, readonly) NSInteger sequenceLength;

- (UIImage *)imageForCharacter:(unichar)character; // for subclass

@property (nonatomic, copy) void(^updateBlock)(void);

@end
