//
//  BeanGameSoundManager.h
//  Beans
//
//  Created by 吴天 on 23/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeanGameSoundManager : NSObject

+ (instancetype)sharedManager;

- (void)beginBackgroundMusicPlayback;
- (void)endBackgroundMusicPlayback;

- (void)playGo;
- (void)playBite;

@end
