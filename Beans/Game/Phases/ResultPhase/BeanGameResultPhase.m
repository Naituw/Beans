//
//  BeanGameResultPhase.m
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameResultPhase.h"
#import "BeanGamePhase+SubClass.h"
#import "BeanBlurView.h"
#import "BeanGameResultView.h"
#import "BeanGameSoundManager.h"

@interface BeanGameResultPhase ()

@property (nonatomic, strong) BeanBlurView * blurView;
@property (nonatomic, strong) BeanGameResultView * resultView;

@end

@implementation BeanGameResultPhase

- (void)_runPhase
{
    [self.contentView addSubview:self.blurView];
    _blurView.frame = self.contentView.bounds;
    
    [self.contentView addSubview:self.resultView];
    _resultView.frame = self.contentView.bounds;

    _resultView.transform = CGAffineTransformMakeScale(0.3, 0.3);
    _resultView.alpha = 0.0;
    
    [[BeanGameSoundManager sharedManager] playCheer];
        
    [UIView animateWithDuration:1.5 delay:0.0 usingSpringWithDamping:0.9 initialSpringVelocity:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _resultView.alpha = 1.0;
        _resultView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
    
    [UIView animateWithDuration:1.5 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        
        UIBlurEffect * effect = nil;
        if (@available(iOS 10.0, *)) {
#warning Private API here!
            effect = [NSClassFromString(@"_UICustomBlurEffect") effectWithStyle:UIBlurEffectStyleLight];
            [effect setValue:[UIColor colorWithWhite:0.0 alpha:0.1] forKey:@"colorTint"];
            [effect setValue:@(0.0) forKey:@"colorTintAlpha"];
            [effect setValue:@(0.0) forKey:@"grayscaleTintAlpha"];
            [effect setValue:@(16) forKey:@"blurRadius"];
        } else {
            effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        }
        
        _blurView.effect = effect;
    } completion:NULL];
    
    [self.resultView startAnimating];
    
    [self performSelector:@selector(finish) withObject:nil afterDelay:3];
}

- (BeanBlurView *)blurView
{
    if (!_blurView) {
        _blurView = [[BeanBlurView alloc] initWithEffect:nil];
    }
    return _blurView;
}

- (BeanGameResultView *)resultView
{
    if (!_resultView) {
        _resultView = [[BeanGameResultView alloc] initWithScore:self.score];
    }
    return _resultView;
}

- (void)finish
{
    self.state = BeanGamePhaseStateCompleted;
}

@end
