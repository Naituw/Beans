//
//  BeanGameSoundManager.m
//  Beans
//
//  Created by 吴天 on 23/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameSoundManager.h"
#import <AVFoundation/AVFoundation.h>

@interface BeanGameSoundManager ()

@property (nonatomic, assign) NSInteger backgroundMusicClientCount;
@property (nonatomic, strong) AVAudioPlayer * backgroundMusicPlayer;
@property (nonatomic, assign) SystemSoundID goSoundEffect;
@property (nonatomic, assign) SystemSoundID biteSoundEffect;

@end

@implementation BeanGameSoundManager

+ (instancetype)sharedManager
{
    static BeanGameSoundManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[BeanGameSoundManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        NSString * bgPath = [[NSBundle mainBundle] pathForResource:@"soundeffect_bg" ofType:@"mp3"];
        NSString * goPath = [[NSBundle mainBundle] pathForResource:@"soundeffect_go" ofType:@"wav"];
        NSString * bitePath = [[NSBundle mainBundle] pathForResource:@"soundeffect_eat" ofType:@"m4a"];
        
        _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:bgPath] error:NULL];
        _backgroundMusicPlayer.volume = 0.8;
        [_backgroundMusicPlayer prepareToPlay];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:goPath], &_goSoundEffect);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:bitePath], &_biteSoundEffect);
    }
    return self;
}

- (void)beginBackgroundMusicPlayback
{
    self.backgroundMusicClientCount++;
}

- (void)endBackgroundMusicPlayback
{
    if (_backgroundMusicClientCount == 0) {
        return;
    }
    self.backgroundMusicClientCount--;
}

- (void)setBackgroundMusicClientCount:(NSInteger)backgroundMusicClientCount
{
    if (_backgroundMusicClientCount != backgroundMusicClientCount) {
        _backgroundMusicClientCount = backgroundMusicClientCount;
        
        if (backgroundMusicClientCount > 0) {
            [_backgroundMusicPlayer play];
        } else {
            [_backgroundMusicPlayer pause];
            [_backgroundMusicPlayer setCurrentTime:0];
        }
    }
}

- (void)playGo
{
    AudioServicesPlaySystemSound(_goSoundEffect);
}

- (void)playBite
{
    AudioServicesPlaySystemSound(_biteSoundEffect);
}

@end
