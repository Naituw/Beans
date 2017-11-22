//
//  BeanGameScoreHintView.h
//  Beans
//
//  Created by 吴天 on 22/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanImageSequenceView.h"

@interface BeanGameScoreHintView : BeanImageSequenceView

+ (instancetype)hintViewWithCombo:(NSInteger)combo;
+ (instancetype)hintViewWithMiss:(NSInteger)score;
+ (instancetype)hintViewWithGreat;

@end
