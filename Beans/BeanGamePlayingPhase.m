//
//  BeanGamePlayingPhase.m
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGamePlayingPhase.h"
#import "BeanGamePhase+SubClass.h"
#import "BeanView+SubClass.h"
#import "BeanView+Private.h"
#import "BeansGenerator.h"
#import "BeanLayerContainerView.h"
#import "BeanGameDefines.h"
#import "BeanScoreView.h"
#import "BeanScoreView.h"
#import "BeanGameResource.h"
#import "EXTScope.h"
#import "UIView+WBTSizes.h"

@interface BeanGamePlayingPhase ()

@property (nonatomic, strong) BeansGenerator * generator;
@property (nonatomic, assign) CGPoint leftMouthPoint;
@property (nonatomic, assign) CGPoint rightMouthPoint;
@property (nonatomic, assign) CFTimeInterval mostRecentBiteTime;
@property (nonatomic, strong) BeanScoreView * scoreView;

@end

@implementation BeanGamePlayingPhase

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)_gameWillStart
{
    _scoreView = [[BeanScoreView alloc] init];
    @weakify(self);
    [_scoreView setSizeUpdateBlock:^{
        @strongify(self);
        [self layout];
    }];
    [self.contentView addSubview:_scoreView];
    
    [self layout];
}

- (void)layout
{
    _scoreView.wbtRight = self.contentView.wbtWidth - 15;
    _scoreView.wbtTop = 10 + 22;
}

- (void)_runPhase
{
    NSLog(@"Start Playing");
    
    _generator = [[BeansGenerator alloc] initWithContentView:self.contentView];
    
    __weak typeof(self) weakSelf = self;
    [_generator setUpdateBlock:^{
        __strong typeof(self) this = weakSelf;
        if (!this) {
            return;
        }
        
        BeansGenerator * gen = this.generator;
        NSTimeInterval timeElapsed = gen.timeElapsed;
        
        if (timeElapsed > (BeanGameDuration - 4)) {
            [gen stopGenerating];
        }
        
        NSTimeInterval remainTime = BeanGameDuration - timeElapsed;
        if (remainTime <= 0) {
            [gen stopUpdating];
            [this setState:BeanGamePhaseStateCompleted];
        } else {
            [this _updateBeans];
        }
    }];
    
    [_generator start];
}

- (void)setLeftMouthPoint:(CGPoint)leftPoint rightMouthPoint:(CGPoint)rightPoint
{
    _leftMouthPoint = leftPoint;
    _rightMouthPoint = rightPoint;
}

- (void)bite
{
    _mostRecentBiteTime = CFAbsoluteTimeGetCurrent();
    [self _updateBeans];
}

- (void)unbite
{
    _mostRecentBiteTime = 0;
}

- (void)_missBeans:(NSInteger)count
{
    NSLog(@"miss beans: %zd", count);
}

- (void)_biteBeans:(NSArray<BeanView *> *)beans
{
    NSMutableArray<BeanLayerContainerView *> * containerViews = [NSMutableArray array];
    for (BeanView * beanView in beans) {
        BeanLayerContainerView * containerView = [[BeanLayerContainerView alloc] initWithBeanView:beanView];
        [self.contentView addSubview:containerView];
        [beanView bite];
        [containerViews addObject:containerView];
    }
    
    CGRect bounds = self.contentView.bounds;
    
    [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction animations:^{
        
        for (BeanLayerContainerView * containerView in containerViews) {
            CGRect frame = containerView.frame;

            if (containerView.beanView.biteMouthPosition < 0.5) {
                // throw left
                frame.origin.x = bounds.origin.x - frame.size.width;
            } else {
                // throw right
                frame.origin.x = bounds.size.width;
            }
            frame.origin.y -= 100; // throw up
            
            containerView.frame = frame;
        }
    } completion:^(BOOL finished) {
        [containerViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

static BOOL OvalHitTest(CGPoint center, CGFloat radius, CGPoint linePoint1, CGPoint linePoint2, CGPoint * fdOut)
{
    CGFloat l2c = sqrt(pow(center.x - linePoint1.x, 2) + pow(center.y - linePoint1.y, 2));
    CGFloat r2c = sqrt(pow(center.x - linePoint2.x, 2) + pow(center.y - linePoint2.y, 2));
    
    if (l2c <= radius || r2c <= radius) {
        // if mouse endpoint inside oval
        if (fdOut) {
            if (l2c > r2c) {
                *fdOut = linePoint2;
            } else {
                *fdOut = linePoint1;
            }
        }
        return YES;
    }
    
    double A = linePoint2.y - linePoint1.y;
    double B = linePoint1.x - linePoint2.x;
    double C = linePoint2.x * linePoint1.y - linePoint1.x * linePoint2.y;
    
    double distanceToLine = ABS((A * center.x + B * center.y + C) / sqrt(A * A + B * B));
    
    if (distanceToLine > radius) {
        return NO;
    }
    
    double fdx = (B * B * center.x - A * B * center.y - A * C) / (A * A + B * B);
    double fdy = (-A * B * center.x + A * A * center.y - B * C) / (A * A + B * B);
    
    if (fdx > linePoint1.x && fdx > linePoint2.x) {
        return NO;
    }
    
    if (fdx < linePoint1.x && fdx < linePoint2.x) {
        return NO;
    }
    
    if (fdy > linePoint1.y && fdy > linePoint2.y) {
        return NO;
    }
    
    if (fdy < linePoint1.y && fdy < linePoint2.y) {
        return NO;
    }
    
    if (fdOut) {
        *fdOut = CGPointMake(fdx, fdy);
    }
    
    return YES;
}

- (void)_updateBeans
{
    NSMutableArray * biteBeans = [NSMutableArray array];
    NSMutableArray * outBeans = [NSMutableArray array];
    
    UIView * contentView = self.contentView;
    CGSize contentViewSize = contentView.bounds.size;
    BOOL mouthAreaAvailable = (!CGPointEqualToPoint(_leftMouthPoint, CGPointZero) || !CGPointEqualToPoint(_rightMouthPoint, CGPointZero)) && !CGPointEqualToPoint(_leftMouthPoint, _rightMouthPoint);
    BOOL bites = (CFAbsoluteTimeGetCurrent() - _mostRecentBiteTime) < BeanGameMouthBiteExpires;
    
    NSMutableArray<BeanView *> * currentBeanViews = self.generator.currentBeanViews;
    
    for (BeanView * beanView in currentBeanViews) {
        if (beanView.frame.origin.y >= contentViewSize.height) {
            [outBeans addObject:beanView];
            continue;
        }
        
        if (!bites || !mouthAreaAvailable) {
            continue;
        }
        CGPoint center = beanView.position;
        CGFloat radius = [[beanView class] defaultSize].width / 2 + BeanGameBeanRadiusExtend;
        
        CGPoint fdOut = CGPointZero;
        double extend = 0;
        double extendInterval = 20;
        
        BOOL hit = NO;
        while (!hit && extend <= BeanGameMouthBottomExtend) {
            if (OvalHitTest(center, radius, CGPointMake(_leftMouthPoint.x, _leftMouthPoint.y + extend), CGPointMake(_rightMouthPoint.x, _rightMouthPoint.y + extend), &fdOut)) {
                hit = YES;
                break;
            }
            
            if (extend == BeanGameMouthBottomExtend) {
                break;
            }
            
            extend += extendInterval;
            extend = MIN(extend, BeanGameMouthBottomExtend);
        }
        
        if (hit) {
            [biteBeans addObject:beanView];
            
            double progress = (fdOut.x - _leftMouthPoint.x) / (_rightMouthPoint.x - _leftMouthPoint.x);
            progress = MAX(0, MIN(progress, 1));
            [beanView setBiteMouthPosition:progress];
        }
    }
    
    NSInteger numberOfPositiveBeans = 0;
    for (BeanView * beanView in outBeans) {
        [currentBeanViews removeObject:beanView];
        [beanView removeFromSuperlayer];
        if (beanView.score > 0) {
            numberOfPositiveBeans++;
        }
    }
    
    if (numberOfPositiveBeans) {
        [self _missBeans:numberOfPositiveBeans];
    }
    
    if (biteBeans.count) {
        for (BeanView * beanView in biteBeans) {
            [currentBeanViews removeObject:beanView];
        }
        [self _biteBeans:biteBeans];
    }
}

- (void)_mockScores
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _scoreView.score = 200;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _scoreView.score = 400;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _scoreView.score = 1200;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _scoreView.score = 200;
                });
            });
        });
    });
}

@end
