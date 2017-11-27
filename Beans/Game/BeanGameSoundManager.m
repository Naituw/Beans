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
@property (nonatomic, assign) SystemSoundID countEffect;
@property (nonatomic, assign) SystemSoundID goSoundEffect;
@property (nonatomic, assign) SystemSoundID biteSoundEffect;
@property (nonatomic, assign) SystemSoundID cheerEffect;

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
        NSString * bitePath = [[NSBundle mainBundle] pathForResource:@"soundeffect_eat" ofType:@"mp3"];
        NSString * countPath = [[NSBundle mainBundle] pathForResource:@"soundeffect_321" ofType:@"mp3"];
        NSString * cheerPath = [[NSBundle mainBundle] pathForResource:@"soundeffect_cheer" ofType:@"mp3"];
        
        _backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:bgPath] error:NULL];
        [_backgroundMusicPlayer prepareToPlay];
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:goPath], &_goSoundEffect);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:bitePath], &_biteSoundEffect);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:countPath], &_countEffect);
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:cheerPath], &_cheerEffect);
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
        
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(pauseIfNeeded) object:nil];
        
        if (backgroundMusicClientCount > 0) {
            [_backgroundMusicPlayer setVolume:1.0];
            [_backgroundMusicPlayer play];
        } else {
            if (@available(iOS 10.0, *)) {
                [_backgroundMusicPlayer setVolume:0.0 fadeDuration:1.0];
                [self performSelector:@selector(pauseIfNeeded) withObject:nil afterDelay:1.1];
            } else {
                [self performSelector:@selector(pauseIfNeeded)];
            }
        }
    }
}

- (void)pauseIfNeeded
{
    if (_backgroundMusicClientCount) {
        return;
    }
    [_backgroundMusicPlayer pause];
    [_backgroundMusicPlayer setCurrentTime:0.0];
}

- (void)playCount
{
    AudioServicesPlaySystemSound(_countEffect);
}

- (void)playCheer
{
    AudioServicesPlaySystemSound(_cheerEffect);
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
