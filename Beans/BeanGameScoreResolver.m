//
//  BeansGameScoreResolver.m
//  Beans
//
//  Created by 吴天 on 22/11/17.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameScoreResolver.h"
#import "BeanGameDefines.h"
#import "BeanGameScoreHintView.h"
#import "UIView+WBTSizes.h"

@interface BeanGameScoreResolver ()
{
    CFTimeInterval _previousAppendTime;
}

@property (nonatomic, weak) UIView * contentView;
@property (nonatomic, weak) UIView * existingComboView;

@end

@implementation BeanGameScoreResolver

- (instancetype)initWithContentView:(UIView *)contentView
{
    if (self = [self init]) {
        _contentView = contentView;
    }
    return self;
}

- (void)appendScore:(NSInteger)score
{
    if (score < 0) {
        _combo = 0;
        _score += score;
        _previousAppendTime = 0;
        [self _playMissWithScore:score];
    } else {
        CFTimeInterval now = CFAbsoluteTimeGetCurrent();
        if (_combo == 0 || (now - _previousAppendTime) > BeanGameBeanComboInterval) {
            _combo = 1;
            _score += score;
            _previousAppendTime = now;
            [self _playGreat];
        } else {
            _combo++;
            _score += (score * _combo);
            _previousAppendTime = now;
            [self _playCombo];
        }
    }
    _score = MAX(0, _score);
}

- (void)_playFlashWithColor:(UIColor *)color
{
    UIView * flashView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:flashView];
    
    flashView.backgroundColor = color;
    flashView.alpha = 1.0;
    
    [UIView animateWithDuration:0.3 animations:^{
        flashView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [flashView removeFromSuperview];
    }];
}

- (void)_playHintView:(BeanGameScoreHintView *)hintView
{
    if (_existingComboView) {
        [UIView animateWithDuration:0.15 animations:^{
            _existingComboView.wbtCenterY -= 50;
        }];
    }
    
    _existingComboView = hintView;
    _existingComboView.alpha = 0.0;
    [self.contentView addSubview:_existingComboView];
    
    _existingComboView.center = CGPointMake(self.contentView.wbtWidth / 2, self.contentView.wbtHeight - 100);
    _existingComboView.transform = CGAffineTransformMakeScale(2, 2);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        hintView.transform = CGAffineTransformIdentity;
        hintView.alpha = 1.0;
    } completion:^(BOOL finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (hintView == _existingComboView) {
                _existingComboView = nil;
            }
            [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                hintView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [hintView removeFromSuperview];
            }];
        });
    }];
}

- (void)_playMissWithScore:(NSInteger)score
{
    [self _playHintView:[BeanGameScoreHintView hintViewWithMiss:score]];
    NSLog(@"Miss! %zd", score);
    
    [self _playFlashWithColor:[[UIColor redColor] colorWithAlphaComponent:0.2]];
}

- (void)_playGreat
{
    [self _playHintView:[BeanGameScoreHintView hintViewWithGreat]];
    NSLog(@"Great!");
}

- (void)_playCombo
{
    [self _playHintView:[BeanGameScoreHintView hintViewWithCombo:_combo]];
    NSLog(@"Combo! %zd", _combo);
}

@end
