//
//  BeansGenerator.m
//  Beans
//
//  Created by wutian on 2017/11/16.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeansGenerator.h"
#import "BeanNormalBeanView.h"
#import "BeanLargeBeanView.h"
#import "BeanPooPooView.h"
#import "BeanView+Private.h"

@interface BeanView (Chance)

@property (nonatomic, assign, readonly, class) NSInteger chance;

@end

@interface BeansGenerator ()

@property (nonatomic, assign) BOOL generating;
@property (nonatomic, weak) UIView * contentView;
@property (nonatomic, strong) CADisplayLink * displayLink;
@property (nonatomic, assign) CFAbsoluteTime startTime;
@property (nonatomic, assign) CFAbsoluteTime nextBeanTime;
@property (nonatomic, strong) NSMutableSet<Class> * beanClassesNotCreatedYet;
@property (nonatomic, assign) NSTimeInterval mostRencetNotCreatedYetBeanCreationTime;

@end

@implementation BeansGenerator

- (instancetype)initWithContentView:(UIView *)contentView
{
    if (self = [self init]) {
        _contentView = contentView;
        _currentBeanViews = [NSMutableArray array];
    }
    return self;
}

- (void)start
{
    if (_displayLink) {
        return;
    }
    
    _generating = YES;
    _timeElapsed = 0;
    _startTime = CFAbsoluteTimeGetCurrent();
    _nextBeanTime = _startTime;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkCallback:)];
    _beanClassesNotCreatedYet = [NSMutableSet setWithArray:[[self class] supportedBeanClasses]];
    
    [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [_displayLink setPaused:NO];
}

- (void)stopUpdating
{
    if (!_displayLink) {
        return;
    }
    
    [_displayLink invalidate];
    _displayLink = nil;
}

- (void)stopGenerating
{
    _generating = NO;
}

- (void)displayLinkCallback:(id)sender
{
    CFTimeInterval currentTime = CFAbsoluteTimeGetCurrent();
    _timeElapsed = currentTime - _startTime;
    
    if (_generating) {
        if (_nextBeanTime <= currentTime) {
            [self _createBean];
            if ((arc4random() % 2) == 1) {
                // chances to genrate two
                [self _createBean];
            }
            
            CFTimeInterval minBeanInterval = 0.25;
            CFTimeInterval maxBeanInterval = 0.6;
            CFTimeInterval maxBeanIntervalTime = 0;
            CFTimeInterval minBeanIntervalTime = 8;
            
            CFTimeInterval nextBeanInterval = MAX(((minBeanIntervalTime - _timeElapsed) / (minBeanIntervalTime - maxBeanIntervalTime)) * (maxBeanInterval - minBeanInterval), 0) + minBeanInterval;
            _nextBeanTime = currentTime + nextBeanInterval;
        }
    }
    
    [self _updateBeans];
    
    if (_updateBlock) {
        _updateBlock();
    }
}

+ (NSArray<Class> *)supportedBeanClasses
{
    static NSArray<Class> * beanClasses = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        beanClasses = @[[BeanNormalBeanView class], [BeanLargeBeanView class], [BeanPooPooView class]];
    });
    return beanClasses;
}

- (void)_createBean
{
    if (_timeElapsed > 5 && ((int)_mostRencetNotCreatedYetBeanCreationTime != (int)_timeElapsed)) {
        Class anyClass = [_beanClassesNotCreatedYet anyObject];
        if (anyClass) {
            _mostRencetNotCreatedYetBeanCreationTime = _timeElapsed;
            [_beanClassesNotCreatedYet removeObject:anyClass];
            return [self _createBeanWithClass:anyClass];
        }
    }
    
    NSInteger totalChance = 0;
    NSArray<Class> * supportedBeanClasses = [[self class] supportedBeanClasses];
    
    for (Class klass in supportedBeanClasses) {
        totalChance += [klass chance];
    }
    
    NSInteger randomIndex = arc4random() % totalChance;
    for (Class klass in supportedBeanClasses) {
        NSInteger chance = [klass chance];
        if (randomIndex < chance) {
            return [self _createBeanWithClass:klass];
        } else {
            randomIndex -= chance;
        }
    }
}

- (void)_createBeanWithClass:(Class)klass
{
    BeanView * beanView = [klass view];
    beanView.timestamp = CFAbsoluteTimeGetCurrent();
    [_contentView.layer addSublayer:beanView];
    CGRect frame = (CGRect){.origin = CGPointZero, .size = beanView.frame.size};
    frame.origin.y = 0 - frame.size.height;
    
    CGFloat minX = 5;
    CGFloat maxX = _contentView.bounds.size.width - 5 - frame.size.width;
    
    frame.origin.x = ((double)(arc4random() % 100) / 100.0) * (maxX - minX) + minX;
    beanView.frame = frame;
    
    [_currentBeanViews addObject:beanView];
    
    [beanView startRotationAnimation];
}

- (void)_updateBeans
{
    double accRatePerSec = 180;
    CFTimeInterval now = CFAbsoluteTimeGetCurrent();
    
    [CATransaction begin];
    for (BeanView * beanView in _currentBeanViews) {
        CFTimeInterval t = beanView.timestamp;
        CFTimeInterval eplashed = now - t;
        beanView.velocity += eplashed * accRatePerSec;
        CGRect frame = beanView.frame;
        frame.origin.y += beanView.velocity * eplashed;
        beanView.frame = frame;
        beanView.timestamp = now;
    }
    [CATransaction commit];
}

@end

@implementation BeanView (Chance)

+ (NSInteger)chance
{
    return 1;
}

@end

#define DefineChance(__CLASS__, __CHANCE__) \
@interface __CLASS__ (Chance) @end \
@implementation __CLASS__ (Chance) \
+ (NSInteger)chance { return __CHANCE__;} \
@end

DefineChance(BeanNormalBeanView, 8)
DefineChance(BeanLargeBeanView, 2)
DefineChance(BeanPooPooView, 5)

#undef DefineChance
