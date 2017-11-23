//
//  BeanAnimatedCountView.m
//  Beans
//
//  Created by wutian on 2017/11/21.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanAnimatedCountView.h"
#import "BeanNoAnimationLayer.h"

@interface BeanAnimatedCountView ()
{
    struct {
        BOOL animating;
        NSTimeInterval remainDuration;
        CFTimeInterval timestamp;
        NSUInteger currentCount;
    } _animate;
}

@property (nonatomic, strong) CADisplayLink * displayLink;
@property (nonatomic, strong) NSArray * numberImages;

@end

@implementation BeanAnimatedCountView

- (instancetype)initWithNumberImages:(NSArray<UIImage *> *)numberImages
{
    if (self = [self initWithFrame:CGRectZero]) {
        self.numberImages = numberImages;
        _count = 0;
        
        [self _updateDisplay];
    }
    return self;
}

- (NSUInteger)presentationCount
{
    return _animate.currentCount;
}

- (void)setCount:(NSUInteger)count
{
    [self setCount:count animateDuration:0];
}

- (void)setCount:(NSUInteger)count animateDuration:(NSTimeInterval)duration
{
    if (_count != count) {
        NSUInteger previousCount = _count;
        _count = count;
        
        _animate.timestamp = CFAbsoluteTimeGetCurrent();
        
        duration = MAX(0, duration);
        
        if (duration > 0) {
            _animate.remainDuration = duration;
            if (_animate.currentCount == 0) {
                _animate.currentCount = previousCount;
            }
            self.animating = YES;
        } else {
            self.animating = NO;
            _animate.remainDuration = 0;
            _animate.currentCount = count;
        }
    }
}

- (UIImage *)imageForCharacter:(unichar)character
{
    NSUInteger number = character - 48;
    number = MIN(number, 9);
    UIImage * image = _numberImages[number];
    return image;
}

- (NSUInteger)digitCount
{
    return self.sequenceLength;
}

- (void)_updateDisplay
{
    NSString * displayString = [NSString stringWithFormat:@"%zd", _animate.currentCount];
    self.content = displayString;
}

- (void)_updateAnimation
{
    if (_animate.remainDuration <= 0) {
        self.animating = NO;
        return;
    }
    
    NSInteger currentCount = _animate.currentCount;
    NSInteger targetCount = _count;
    
    CFTimeInterval now = CFAbsoluteTimeGetCurrent();
    CFTimeInterval timeDelta = now - _animate.timestamp;
    
    NSInteger countDelta = (targetCount - currentCount) * (timeDelta / _animate.remainDuration);
    
    if (countDelta < 0) {
        countDelta = MAX(countDelta, targetCount - currentCount);
    } else {
        countDelta = MIN(countDelta, targetCount - currentCount);
    }
    
    _animate.currentCount += countDelta;
    _animate.remainDuration -= timeDelta;
    _animate.timestamp = now;
    
    [self _updateDisplay];
    
    if (_animate.remainDuration <= 0) {
        self.animating = NO;
        return;
    }
}

- (void)setAnimating:(BOOL)animating
{
    if (_animate.animating != animating) {
        _animate.animating = animating;
        
        if (animating) {
            _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_updateAnimation)];
            [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
        } else {
            [_displayLink invalidate];
            _displayLink = nil;
        }
    }
}

@end
