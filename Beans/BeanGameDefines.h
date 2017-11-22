//
//  BeanGameDefines.h
//  Beans
//
//  Created by 吴天 on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#ifndef BeanGameDefines_h
#define BeanGameDefines_h

#import "FBTweakInline.h"

#define BeanGameDuration FBTweakValue(@"Game Play", @"General", @"Game Duration", 12.0)
#define BeanGameTouchEnabled FBTweakValue(@"Game Play", @"Control", @"Touch Enabled", YES)
#define BeanGameBeanRadiusExtend 5.0

#define BeanGameBeanAccelerationRate FBTweakValue(@"Game Play", @"Bean Generator", @"Acceleration Rate", 100.0)
#define BeanGameBeanMinBeansPerSecond FBTweakValue(@"Game Play", @"Bean Generator", @"Min Beans/sec", 2)
#define BeanGameBeanMaxBeansPerSecond FBTweakValue(@"Game Play", @"Bean Generator", @"Max Beans/sec", 3)
#define BeanGameBeanGeneratorSpeedUpDuration FBTweakValue(@"Game Play", @"Bean Generator", @"Speedup Duration", 8)

#define BeanGameNormalBeanChance FBTweakValue(@"Game Play", @"Bean Generator", @"Noraml Bean Chance", 8)
#define BeanGameLargeBeanChance FBTweakValue(@"Game Play", @"Bean Generator", @"Large Bean Chance", 1)
#define BeanGamePooChance FBTweakValue(@"Game Play", @"Bean Generator", @"Poopoo Chance", 3)

#define BeanGameBeanNormalSize FBTweakValue(@"Game Play", @"Beans", @"Normal Bean Size", 80.0)
#define BeanGameBeanLargeSize FBTweakValue(@"Game Play", @"Beans", @"Large Bean Size", 120.0)
#define BeanGameBeanPoopooSize FBTweakValue(@"Game Play", @"Beans", @"Poopoo Size", 80.0)

#define BeanGameNormalBeanScore FBTweakValue(@"Game Play", @"Score", @"Normal Bean Score", 100)
#define BeanGameLargeBeanScore FBTweakValue(@"Game Play", @"Score", @"Large Bean Score", 200)
#define BeanGamePoopooScore FBTweakValue(@"Game Play", @"Score", @"Poopoo Score", -400)
#define BeanGameBeanComboInterval FBTweakValue(@"Game Play", @"Score", @"Combo Interval", 1.0)


#define BeanGameMouthBottomExtend FBTweakValue(@"Game Play", @"Face Tracking", @"Mouth Bottom Expand", 40.0)
#define BeanGameMouthBiteExpires FBTweakValue(@"Game Play", @"Face Tracking", @"Bite Lasts Seconds", 0.02)
#define BeanGameMouthOpenSensitivity FBTweakValue(@"Game Play", @"Face Tracking", @"Mouth Open Sensitivity", 0.4)
#define BeanGameMouthTrackDebugging FBTweakValue(@"Game Play", @"Face Tracking", @"Show Mouth", NO)

#endif /* BeanGameDefines_h */
