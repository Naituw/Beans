//
//  BeanGameCountdownPhase.m
//  Beans
//
//  Created by 吴天 on 2017/11/15.
//  Copyright © 2017年 wutian. All rights reserved.
//

#import "BeanGameCountdownPhase.h"
#import "BeanGamePhase+SubClass.h"
#import "BeanGameSoundManager.h"

@interface BeanGameCountdownPhase ()

@property (nonatomic, assign) NSInteger remain;

@end

@implementation BeanGameCountdownPhase

- (void)_runPhase
{
    _remain = 3;
    [self tick];
}

- (void)tick
{
    [self _runAnimationWithRemainTime:_remain];
    if (_remain <= 0) {
        self.state = BeanGamePhaseStateCompleted;
        return;
    }
    _remain--;
    [self performSelector:@selector(tick) withObject:nil afterDelay:1.0];
}

- (void)_runAnimationWithRemainTime:(NSInteger)remain
{
    NSString * imageName = nil;
    if (remain > 0) {
        imageName = [NSString stringWithFormat:@"start_%zd", remain];
    } else {
        imageName = @"start_GO";
    }
    UIImage * image = [UIImage imageNamed:imageName];
    
    if (!image) {
        return;
    }
    
    if (remain > 0) {
        [[BeanGameSoundManager sharedManager] playCount];
    }
    
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    CGPoint center = self.contentView.center;
    imageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    imageView.center = center;
    imageView.alpha = 0.0;
    
    [self.contentView addSubview:imageView];
    
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        imageView.transform = CGAffineTransformIdentity;
        imageView.center = center;
        imageView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.35 delay:0.1 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            imageView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            imageView.center = center;
            imageView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [imageView removeFromSuperview];
        }];
    }];
}

@end
