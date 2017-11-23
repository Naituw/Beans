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
#import "BeanGameDefines.h"

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

@property (nonatomic, strong) NSMutableArray * previouslyCreatedBeans;
@property (nonatomic, assign) NSInteger numberOfBeansToPreventOverlay;

@end

@implementation BeansGenerator

- (instancetype)initWithContentView:(UIView *)contentView
{
    if (self = [self init]) {
        _contentView = contentView;
        _currentBeanViews = [NSMutableArray array];
        _previouslyCreatedBeans = [NSMutableArray array];
        _numberOfBeansToPreventOverlay = MAX(0, MIN(BeanGameBeanNumberOfReferenceBeansToPreventOverlay, 4));
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
            if ((arc4random() % 10) > 5) {
                // chances to genrate two
                [self _createBean];
            }
            
            CFTimeInterval minBeanInterval = 1.0 / BeanGameBeanMaxBeansPerSecond;
            CFTimeInterval maxBeanInterval = 1.0 / BeanGameBeanMinBeansPerSecond;
            CFTimeInterval maxBeanIntervalTime = 0;
            CFTimeInterval minBeanIntervalTime = BeanGameBeanGeneratorSpeedUpDuration;
            
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

- (CGFloat)_findOriginXForBeanWithSize:(CGSize)size
{
    CGFloat minX = 5;
    CGFloat maxX = _contentView.bounds.size.width - 5 - size.width;

    if (_previouslyCreatedBeans.count > 0) {
        
        NSArray * sortedPreviouslyCreatedBeans = [_previouslyCreatedBeans sortedArrayUsingComparator:^NSComparisonResult(BeanView * _Nonnull obj1, BeanView * _Nonnull obj2) {
            return [@(obj1.frame.origin.x) compare:@(obj2.frame.origin.x)];
        }];
        
        CGFloat (^find)(CGSize) = ^CGFloat (CGSize size) {
            NSMutableArray<NSValue *> * availableRanges = [NSMutableArray array];
            
            CGFloat baseX = minX;
            CGFloat totalLength = 0;
            
            for (BeanView * beanView in sortedPreviouslyCreatedBeans) {
                CGRect frame = beanView.frame;
                CGFloat beanMaxX = CGRectGetMinX(frame) - size.width;
                if (beanMaxX > baseX) {
                    CGFloat length = beanMaxX - baseX;
                    [availableRanges addObject:[NSValue valueWithCGPoint:CGPointMake(baseX, length)]];
                    totalLength += length;
                }
                baseX = CGRectGetMaxX(frame);
            }
            
            CGFloat beanMaxX = maxX - size.width;
            if (baseX < beanMaxX) {
                CGFloat length = beanMaxX - baseX;
                [availableRanges addObject:[NSValue valueWithCGPoint:CGPointMake(baseX, length)]];
                totalLength += length;
            }
            
            if (availableRanges.count > 0 && totalLength > 0) {
                
                CGFloat resultLocation = floor(totalLength * (double)(arc4random() % 100) / 100.0);
                
                for (NSValue * value in availableRanges) {
                    CGPoint range = [value CGPointValue];
                    if (range.y > resultLocation) {
                        return range.x + resultLocation;
                    } else {
                        resultLocation -= range.y;
                    }
                }
                
                NSAssert(NO, @"should found a location in previous logic");
                
                CGPoint lastRange = [availableRanges.lastObject CGPointValue];
                
                return lastRange.x + lastRange.y;
            }
            return -1;
        };
        
        CGFloat result = find(size);
        if (result < 0) {
            result = find(CGSizeMake(size.width / 2, size.height / 2));
        }
        if (result < 0) {
            result = find(CGSizeMake(size.width / 4, size.height / 4));
        }
        if (result < 0) {
            result = find(CGSizeMake(size.width / 8, size.height / 8));
        }
        if (result >= 0) {
            return result;
        }
    }
    
    return ((double)(arc4random() % 100) / 100.0) * (maxX - minX) + minX;
}

- (void)_createBeanWithClass:(Class)klass
{
    BeanView * beanView = [klass view];
    beanView.timestamp = CFAbsoluteTimeGetCurrent();
    [_contentView.layer addSublayer:beanView];
    CGRect frame = (CGRect){.origin = CGPointZero, .size = beanView.frame.size};
    frame.origin.y = 0 - frame.size.height;
    frame.origin.x = [self _findOriginXForBeanWithSize:frame.size];
    beanView.frame = frame;
    
    [_currentBeanViews addObject:beanView];
    
    if (_numberOfBeansToPreventOverlay > 0) {
        while (_previouslyCreatedBeans.count > (_numberOfBeansToPreventOverlay - 1)) {
            [_previouslyCreatedBeans removeObjectAtIndex:0];
        }
        [_previouslyCreatedBeans addObject:beanView];
    }
    
    [beanView startRotationAnimation];
}

- (void)_updateBeans
{
    double accRatePerSec = BeanGameBeanAccelerationRate;
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

DefineChance(BeanNormalBeanView, BeanGameNormalBeanChance)
DefineChance(BeanLargeBeanView, BeanGameLargeBeanChance)
DefineChance(BeanPooPooView, BeanGamePooChance)

#undef DefineChance
