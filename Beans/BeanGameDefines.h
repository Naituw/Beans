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

#define BeanGameBeanRadiusExtend 5.0

#define BeanGameBeanAccelerationRate FBTweakValue(@"Generator", @"Bean Generator", @"Acceleration Rate", 100.0)
#define BeanGameBeanMinBeansPerSecond FBTweakValue(@"Generator", @"Bean Generator", @"Min Beans/sec", 2)
#define BeanGameBeanMaxBeansPerSecond FBTweakValue(@"Generator", @"Bean Generator", @"Max Beans/sec", 3)
#define BeanGameBeanGeneratorSpeedUpDuration FBTweakValue(@"Generator", @"Bean Generator", @"Speedup Duration", 8)

#define BeanGameNormalBeanChance FBTweakValue(@"Generator", @"Bean Generator", @"Noraml Bean Chance", 8)
#define BeanGameLargeBeanChance FBTweakValue(@"Generator", @"Bean Generator", @"Large Bean Chance", 1)
#define BeanGamePooChance FBTweakValue(@"Generator", @"Bean Generator", @"Poopoo Chance", 3)

#define BeanGameBeanNormalSize FBTweakValue(@"Generator", @"Beans", @"Normal Bean Size", 80.0)
#define BeanGameBeanLargeSize FBTweakValue(@"Generator", @"Beans", @"Large Bean Size", 120.0)
#define BeanGameBeanPoopooSize FBTweakValue(@"Generator", @"Beans", @"Poopoo Size", 80.0)

#define BeanGameDuration FBTweakValue(@"General", @"Gaming", @"Game Duration", 12.0)
#define BeanGameTouchEnabled FBTweakValue(@"General", @"Gaming", @"Touch Enabled", YES)

#define BeanGameNormalBeanScore FBTweakValue(@"General", @"Score", @"Normal Bean Score", 100)
#define BeanGameLargeBeanScore FBTweakValue(@"General", @"Score", @"Large Bean Score", 200)
#define BeanGamePoopooScore FBTweakValue(@"General", @"Score", @"Poopoo Score", -400)
#define BeanGameBeanComboInterval FBTweakValue(@"General", @"Combo", @"Combo Interval", 1.0)

#define BeanGameCountDownPhaseEnabled FBTweakValue(@"General", @"Phases", @"#1 Count Down", YES)
#define BeanGamePlayingPhaseEnabled FBTweakValue(@"General", @"Phases", @"#2 Playing", YES)
#define BeanGameResultPhaseEnabled FBTweakValue(@"General", @"Phases", @"#3 Result", YES)

#define BeanGameMouthBottomExtend FBTweakValue(@"Tracking", @"Face Tracking", @"Mouth Bottom Expand", 40.0)
#define BeanGameMouthBiteExpires FBTweakValue(@"Tracking", @"Face Tracking", @"Bite Lasts Seconds", 0.02)
#define BeanGameMouthOpenSensitivity FBTweakValue(@"Tracking", @"Face Tracking", @"Mouth Open", 0.4, 0.0, 1.0)
#define BeanGameMouthTrackDebugging FBTweakValue(@"Tracking", @"Face Tracking", @"Show Mouth", NO)


#endif /* BeanGameDefines_h */
