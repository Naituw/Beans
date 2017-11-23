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
#import "BeanGameScoreResolver.h"
#import "BeanGameProgressBar.h"
#import "EXTScope.h"
#import "UIView+WBTSizes.h"

@interface BeanGamePlayingPhase ()

@property (nonatomic, strong) BeansGenerator * generator;
@property (nonatomic, strong) BeanGameScoreResolver * scoreResolver;
@property (nonatomic, assign) CGPoint leftMouthPoint;
@property (nonatomic, assign) CGPoint rightMouthPoint;
@property (nonatomic, assign) CFTimeInterval mostRecentBiteTime;
@property (nonatomic, strong) UIView * beansContainerView;
@property (nonatomic, strong) BeanScoreView * scoreView;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, strong) UITapGestureRecognizer * simulatorTapGesture;
@property (nonatomic, strong) BeanGameProgressBar * progressBar;

@end

@implementation BeanGamePlayingPhase

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)setScore:(NSInteger)score
{
    if (_score != score) {
        _score = score;
        
        _scoreView.score = score;
    }
}

- (void)_gameWillStart
{
    _beansContainerView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    _beansContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:_beansContainerView];
    
    _scoreView = [[BeanScoreView alloc] init];
    @weakify(self);
    [_scoreView setSizeUpdateBlock:^{
        @strongify(self);
        [self layout];
    }];
    [self.contentView addSubview:_scoreView];
    
    _progressBar = [[BeanGameProgressBar alloc] initWithFrame:CGRectZero];
    _progressBar.progress = 1.0;
    [self.contentView addSubview:_progressBar];
    
    [self layout];
}

- (void)layout
{
    _scoreView.wbtRight = self.contentView.wbtWidth - 15;
    _scoreView.wbtTop = 10 + self.contentView.safeAreaInsets.top;
    
    CGFloat height = 8;
    _progressBar.frame = CGRectMake(10, self.contentView.wbtHeight - height - MAX(self.contentView.safeAreaInsets.bottom, 16), self.contentView.wbtWidth - 10 * 2, height);
}

- (void)_runPhase
{
    NSLog(@"Start Playing");
    
    if (BeanGameTouchEnabled) {
        if (!_simulatorTapGesture) {
            _simulatorTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognized:)];
            _simulatorTapGesture.numberOfTapsRequired = 1;
            [self.contentView addGestureRecognizer:_simulatorTapGesture];
        }
    }
    
    _scoreResolver = [[BeanGameScoreResolver alloc] initWithContentView:self.contentView];
    
    _generator = [[BeansGenerator alloc] initWithContentView:self.beansContainerView];
    
    CGFloat distance = self.contentView.wbtHeight + BeanGameBeanLargeSize;
    NSTimeInterval timeFromTopToBottom = sqrt(2 * distance / BeanGameBeanAccelerationRate);
    
    @weakify(self);
    [_generator setUpdateBlock:^{
        @strongify(self);
        if (!self) {
            return;
        }
        
        BeansGenerator * gen = self.generator;
        NSTimeInterval timeElapsed = gen.timeElapsed;
        
        if (timeElapsed > (BeanGameDuration - timeFromTopToBottom)) {
            [gen stopGenerating];
        }
        
        NSTimeInterval remainTime = BeanGameDuration - timeElapsed;
        if (remainTime <= 0) {
            [self.progressBar setProgress:0.0];
            [gen stopUpdating];
            [self setState:BeanGamePhaseStateCompleted];
        } else {
            [self.progressBar setProgress:(remainTime / BeanGameDuration)];
            [self _updateBeans];
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
    
    NSInteger positiveScore = 0;
    NSInteger negativeScore = 0;
    
    for (BeanView * beanView in beans) {
        BeanLayerContainerView * containerView = [[BeanLayerContainerView alloc] initWithBeanView:beanView];
        [self.contentView addSubview:containerView];
        [beanView bite];
        [containerViews addObject:containerView];
        
        NSInteger score = beanView.score;
        if (score > 0) {
            positiveScore += score;
        } else {
            negativeScore += score;
        }
    }
    
    if (negativeScore) {
        [_scoreResolver appendScore:negativeScore];
    } else {
        [_scoreResolver appendScore:positiveScore];
    }
    
    self.score = _scoreResolver.score;
    
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

- (BeanView *)beanViewAtLocation:(CGPoint)location
{
    for (BeanView * beanView in self.generator.currentBeanViews.reverseObjectEnumerator) {
        if (CGRectContainsPoint(CGRectInset(beanView.frame, -BeanGameBeanRadiusExtend, -BeanGameBeanRadiusExtend), location)) {
            return beanView;
        }
    }
    return nil;
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGesture
{
    if (tapGesture.state == UIGestureRecognizerStateRecognized) {
        CGPoint location = [tapGesture locationInView:self.contentView];
        BeanView * beanView = [self beanViewAtLocation:location];
        if (beanView) {
            [self.generator.currentBeanViews removeObject:beanView];
            [self _biteBeans:@[beanView]];
        }
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
