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

#define BeanGameBeanAccelerationRate FBTweakValue(@"豆子发生器", @"豆子发生器", @"加速度", 110.0)
#define BeanGameBeanMinBeansPerSecond FBTweakValue(@"豆子发生器", @"豆子发生器", @"最少豆子/秒", 2)
#define BeanGameBeanMaxBeansPerSecond FBTweakValue(@"豆子发生器", @"豆子发生器", @"最多豆子/秒", 4)
#define BeanGameBeanGeneratorSpeedUpDuration FBTweakValue(@"豆子发生器", @"豆子发生器", @"数量加速时长", 8)
#define BeanGameBeanNumberOfReferenceBeansToPreventOverlay FBTweakValue(@"豆子发生器", @"豆子发生器", @"防重叠参考个数", 3, 0, 4)

#define BeanGameNormalBeanChance FBTweakValue(@"豆子", @"几率", @"普通豆几率", 8)
#define BeanGameLargeBeanChance FBTweakValue(@"豆子", @"几率", @"巨型豆几率", 1)
#define BeanGamePooChance FBTweakValue(@"豆子", @"几率", @"大便几率", 3)

#define BeanGameBeanNormalSize FBTweakValue(@"豆子", @"大小", @"普通豆大小", 68.0)
#define BeanGameBeanLargeSize FBTweakValue(@"豆子", @"大小", @"巨型豆大小", 150.0)
#define BeanGameBeanPoopooSize FBTweakValue(@"豆子", @"大小", @"大便大小", 68.0)

#define BeanGameNormalBeanScore FBTweakValue(@"豆子", @"得分", @"普通豆得分", 100)
#define BeanGameLargeBeanScore FBTweakValue(@"豆子", @"得分", @"巨型豆得分", 200)
#define BeanGamePoopooScore FBTweakValue(@"豆子", @"得分", @"大便得分", -400)


#define BeanGameDuration FBTweakValue(@"游戏", @"游戏", @"游戏时长", 12.0)
#define BeanGameTouchEnabled FBTweakValue(@"游戏", @"游戏", @"通过点击吃豆", YES)

#define BeanGameBeanComboInterval FBTweakValue(@"游戏", @"连击", @"连击最大间隔", 1.0)

#define BeanGameCountDownPhaseEnabled FBTweakValue(@"游戏", @"场景", @"#1 倒计时", YES)
#define BeanGamePlayingPhaseEnabled FBTweakValue(@"游戏", @"场景", @"#2 吃豆子", YES)
#define BeanGameResultPhaseEnabled FBTweakValue(@"游戏", @"场景", @"#3 结果展示", YES)

#define BeanGameMouthBottomExtend FBTweakValue(@"面部追踪", @"面部追踪", @"嘴巴下缘范围", 40.0)
#define BeanGameMouthBiteExpires FBTweakValue(@"面部追踪", @"面部追踪", @"单次吃豆有效时间", 0.02)
#define BeanGameMouthOpenSensitivity FBTweakValue(@"面部追踪", @"面部追踪", @"张嘴大小", 0.4, 0.0, 1.0)
#define BeanGameMouthTrackDebugging FBTweakValue(@"面部追踪", @"面部追踪", @"显示嘴巴区域", NO)


//#define BeanGameBeanAccelerationRate FBTweakValue(@"Generator", @"Bean Generator", @"Acceleration Rate", 100.0)
//#define BeanGameBeanMinBeansPerSecond FBTweakValue(@"Generator", @"Bean Generator", @"Min Beans/sec", 2)
//#define BeanGameBeanMaxBeansPerSecond FBTweakValue(@"Generator", @"Bean Generator", @"Max Beans/sec", 3)
//#define BeanGameBeanGeneratorSpeedUpDuration FBTweakValue(@"Generator", @"Bean Generator", @"Speedup Duration", 8)
//
//#define BeanGameNormalBeanChance FBTweakValue(@"Generator", @"Bean Generator", @"Noraml Bean Chance", 8)
//#define BeanGameLargeBeanChance FBTweakValue(@"Generator", @"Bean Generator", @"Large Bean Chance", 1)
//#define BeanGamePooChance FBTweakValue(@"Generator", @"Bean Generator", @"Poopoo Chance", 3)
//
//#define BeanGameBeanNormalSize FBTweakValue(@"Generator", @"Beans", @"Normal Bean Size", 68.0)
//#define BeanGameBeanLargeSize FBTweakValue(@"Generator", @"Beans", @"Large Bean Size", 150.0)
//#define BeanGameBeanPoopooSize FBTweakValue(@"Generator", @"Beans", @"Poopoo Size", 68.0)
//
//#define BeanGameDuration FBTweakValue(@"General", @"Gaming", @"Game Duration", 10.0)
//#define BeanGameTouchEnabled FBTweakValue(@"General", @"Gaming", @"Touch Enabled", YES)
//
//#define BeanGameNormalBeanScore FBTweakValue(@"General", @"Score", @"Normal Bean Score", 100)
//#define BeanGameLargeBeanScore FBTweakValue(@"General", @"Score", @"Large Bean Score", 200)
//#define BeanGamePoopooScore FBTweakValue(@"General", @"Score", @"Poopoo Score", -400)
//#define BeanGameBeanComboInterval FBTweakValue(@"General", @"Combo", @"Combo Interval", 1.0)
//
//#define BeanGameCountDownPhaseEnabled FBTweakValue(@"General", @"Phases", @"#1 Count Down", YES)
//#define BeanGamePlayingPhaseEnabled FBTweakValue(@"General", @"Phases", @"#2 Playing", YES)
//#define BeanGameResultPhaseEnabled FBTweakValue(@"General", @"Phases", @"#3 Result", YES)
//
//#define BeanGameMouthBottomExtend FBTweakValue(@"Tracking", @"Face Tracking", @"Mouth Bottom Expand", 40.0)
//#define BeanGameMouthBiteExpires FBTweakValue(@"Tracking", @"Face Tracking", @"Bite Lasts Seconds", 0.02)
//#define BeanGameMouthOpenSensitivity FBTweakValue(@"Tracking", @"Face Tracking", @"Mouth Open", 0.4, 0.0, 1.0)
//#define BeanGameMouthTrackDebugging FBTweakValue(@"Tracking", @"Face Tracking", @"Show Mouth", NO)


#endif /* BeanGameDefines_h */
